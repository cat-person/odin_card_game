package my_ecs

import "core:fmt"
import "core:bytes"
import "core:log"
import "core:reflect"
import "core:mem"

World :: struct {
    entities: map[EntityId]Entity,
    components: map[typeid]Query,
    systems: map[typeid]proc(^Query)
}

create_world :: proc(/*mem allocator*/) -> World {
    world := World {}
    return world
}

add_system :: proc(world: ^World, data_type: typeid, system: proc(^Query)) {
    world.systems[data_type] = system
}

add_entity :: proc (world: ^World, components: []any) -> EntityId {
    component_map := map[typeid][]byte {}
    for component in components {
        log.error("add_entity", component)
        info := reflect.type_info_base(type_info_of(component.id))
        log.error("add_entity info size", info.size)

        component_bytes := make([]byte, info.size)

        log.error("add_entity component.data", component.data)

        mem.copy(raw_data(component_bytes), component.data, info.size)

        component_map[component.id] = component_bytes
    }

    entity_id := calc_entity_id(world)
    world.entities[entity_id] = Entity {
        id = entity_id,
        components = component_map
    }
    return entity_id
}

denormilise_entities :: proc(entities: ^map[EntityId]Entity, systems: map[typeid]proc(^Query)) -> map[typeid]Query {
    queries := map[typeid]Query {}

    for data_type in systems {
        entity_data := make([dynamic]byte, 0, 16)

        for entity_id, entity in entities {
            log.error("denormilise_entities entity", entity)
            for component_id, component_data in entity.components {

                if(component_id == data_type) {
//                    for component_byte in component_data {
                    append(&entity_data, ..component_data)
//                    }
                }
            }
        }
        queries[data_type] = Query {
            data_type = data_type,
            data = entity_data[:]
        }
    }

//    log.error("denormilise_entities component_data queries", queries)

    return queries
}

update_world ::proc(world: ^World) {
    components := denormilise_entities(&world.entities, world.systems)

    log.error("update_world entities = ", world.entities)
    log.error("update_world systems = ", world.systems)

    log.error("update_world components = ", components)

    for data_type in world.systems {
        if(data_type in components) {
            query := components[data_type]

            log.error("update_world data_type = ", data_type)
            log.error("update_world query = ", query)

            world.systems[data_type](&query)
        }
    }
}