package my_ecs

import "core:fmt"
import "core:bytes"
import "core:log"
import "core:reflect"
import "core:mem"

World :: struct {
    entities: map[EntityId]Entity,

    components: map[ComponentKey]Query,
    systems: map[ComponentKey]proc(^Query)
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

denormilise_entities :: proc(entities: ^map[EntityId]Entity, systems: map[ComponentKey]proc(^Query)) -> map[ComponentKey]Query {
    queries := map[ComponentKey]Query {}

    for component_key in systems {
        entity_data := make([dynamic]byte, 0, 16)

        switch _ in component_key {
            case typeid:  {
                log.error("created single parameter query", component_key)
                for entity_id, entity in entities {
                    for component_id, component_data in entity.components {
                        if(component_id == component_key) {
                            append(&entity_data, ..component_data)
                        }
                    }
                }
                queries[component_key] = Query {
                    data_type = component_key,
                    data = entity_data[:]
                }
            }
            case [2]typeid,
                [3]typeid,
                [4]typeid,
                [5]typeid,
                [6]typeid: {
                log.error("created multi parameter query", component_key)
                for entity_id, entity in entities {
                    for component_id, component_data in entity.components {

                    }
                }
            }
        }
    }

    return queries
}

update_world ::proc(world: ^World) {
    components := denormilise_entities(&world.entities, world.systems)

    for data_type in world.systems {
        // TODO need to find components
        if(data_type in components) {
            query := components[data_type]
            world.systems[data_type](&query)
        }
    }
}

ComponentKey :: union {
    typeid,
    [2]typeid,
    [3]typeid,
    [4]typeid,
    [5]typeid,
    [6]typeid,
}