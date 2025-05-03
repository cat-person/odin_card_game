#+feature dynamic-literals
package my_ecs

import "core:fmt"
import "core:bytes"
import "core:log"
import "core:reflect"
import "core:mem"

World :: struct {
    entities: map[EntityId]Entity,

    components: map[ComponentKey]Query,
    systems: map[ComponentKey][dynamic]proc(^World, ^Query),
    events: map[EventId][dynamic]any,
    event_handlers: map[typeid]proc(^World, EntityId, []any),
}

create_world :: proc(/*mem allocator*/) -> World {
    world := World {}
    return world
}

add_entity :: proc (world: ^World, components: ..any) -> EntityId {
    component_map := map[typeid][]byte {}
    for component in components {
        component_size := reflect.type_info_base(type_info_of(component.id)).size
        component_bytes := make([]byte, component_size)
        mem.copy(raw_data(component_bytes), component.data, component_size)
        component_map[component.id] = component_bytes
    }

    entity_id := calc_entity_id(world)
    world.entities[entity_id] = Entity {
        id = entity_id,
        components = component_map
    }
    return entity_id
}

add_event :: proc(world: ^World, entity_id: EntityId, event: any) {
    event_id := EventId {
        entity_id = entity_id,
        evnet_type = event.id
    }

    if !(event_id in world.events) {
        world.events[event_id] = [dynamic]any{  }
    }
    append(&world.events[event_id], event)
}

add_event_handler :: proc(world: ^World, $TEvent: typeid, event_handler: proc (world: ^World, entity_id: EntityId, events: []any)) {
    world.event_handlers[TEvent] = event_handler
}

handle_events :: proc(world: ^World) {
    log.error("handle_events world", world)
    for rename_me_event_id, event_handler in world.event_handlers {
        log.error("handle_events event_handler", event_handler)
        for event_id, event_list in world.events {
            log.error("handle_events event_id", event_id)
            event_handler(world, event_id.entity_id, event_list[:])
        }
    }

    delete(world.events)
}

update_world ::proc(world: ^World) {
    components := denormilise_entities(&world.entities, world.systems)

    for data_type in world.systems {
        if(data_type in components) {
            query := components[data_type]
            for system in world.systems[data_type] {
                system(world, &query)
            }
        }
    }

    handle_events(world)
}

EventId :: struct {
    entity_id: EntityId,
    evnet_type: typeid
}