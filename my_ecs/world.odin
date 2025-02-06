package my_ecs

import "core:fmt"
import "core:bytes"
import "core:log"
import "core:reflect"
import "core:mem"

World :: struct {
    entities: map[EntityId]Entity,
    components: map[ComponentKey]Query,
    systems: map[ComponentKey][dynamic]proc(^Query) -> EventMap,
    event_handlers: map[typeid]proc(^World, EntityId, any),
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

add_event :: proc(event_map: ^map[EventKey]any, entity_id: EntityId, event: any) {
    if(event == nil) {
        return
    }

    log.error("add_event", event)

    event_key := EventKey {
        entity_id = entity_id,
        event_type = event.id
    }

    log.error("add_event event_map:", event_map)
    event_map[event_key] = event
    log.error("add_event event_map:", event_map)
}

add_event_handler :: proc(world: ^World, $TEvent: typeid, event_handler: proc (world: ^World, entity_id: EntityId, event: any)) {
    world.event_handlers[TEvent] = event_handler
}

handle_events :: proc(world: ^World, event_map: EventMap) {
    log.error("handle_events", event_map)
    //for event_type_id, event_handler in world.event_handlers {
    for event_id, event in event_map {
        if event_id.event_type in world.event_handlers {
            world.event_handlers[event_id.event_type](world, event_id.entity_id, event)
        }
    }

}

update_world ::proc(world: ^World) {
    components := denormilise_entities(&world.entities, world.systems)

    all_events := make(EventMap)

    for data_type in world.systems {
        if(data_type in components) {
            query := components[data_type]
            for system in world.systems[data_type] {
                event_map := system(&query)
                log.error("update_world Events:", event_map)
                if(event_map != nil) {
                    for event_id, event in event_map {
                        all_events[event_id] = event
                    }
                }
            }
        }
    } // <== Add event goes here
    handle_events(world, all_events)
}

EventKey :: struct {
    entity_id: EntityId,
    event_type: typeid
}

EventMap :: map[EventKey]any
