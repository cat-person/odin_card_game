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
    events: map[EntityId][dynamic]any,
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
    if entity_id in world.events {
        append(&world.events[entity_id], event)
    } else {
        world.events[entity_id] = [dynamic]any{ event }
    }
}

add_event_handler :: proc(world: ^World, $TEvent: typeid, event_handler: proc (world: ^World, entity_id: EntityId, events: []any)) {
    world.event_handlers[TEvent] = event_handler
}

handle_events :: proc(world: ^World) {
    for rename_me_event_id, event_handler in world.event_handlers {
        for event_id, event_list in world.events {
            event_handler(world, event_id, event_list[:])
        }
    }
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
}

EventKey :: struct {
    typeid
}
