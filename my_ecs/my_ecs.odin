package my_ecs

import "core:fmt"
import "core:bytes"
import "core:log"
import "core:reflect"
import "core:mem"

World :: struct {
    entities: map[EntityId]Entity,

    components: map[u64]Query,
    systems: map[u64]proc(^Query)
}

create_world :: proc(/*mem allocator*/) -> World {
    world := World {}
    return world
}

add_entity :: proc (world: ^World, components: ..any) -> EntityId {
    component_map := map[u64][]byte {}
    for component in components {
        component_size := reflect.type_info_base(type_info_of(component.id)).size
        component_bytes := make([]byte, component_size)
        mem.copy(raw_data(component_bytes), component.data, component_size)
        component_map[transmute(u64)component.id] = component_bytes
    }

    entity_id := calc_entity_id(world)
    world.entities[entity_id] = Entity {
        id = entity_id,
        components = component_map
    }
    return entity_id
}

denormilise_entities :: proc(entities: ^map[EntityId]Entity, systems: map[u64]proc(^Query)) -> map[u64]Query {
    queries := map[u64]Query {}

    for data_type in systems {
        entity_data := make([dynamic]byte, 0, 16)

        for entity_id, entity in entities {
            for component_id, component_data in entity.components {
                if(component_id == data_type) {
                    append(&entity_data, ..component_data)
                }
            }
        }
        queries[data_type] = Query {
            data_type = transmute(typeid)data_type,
            data = entity_data[:]
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