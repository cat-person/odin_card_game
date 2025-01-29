package my_ecs

import "core:fmt"
import "core:bytes"
import "core:log"

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
    entity_id := calc_entity_id(world)
    world.entities[entity_id] = Entity {
        id = entity_id,
        components = components
    }
    return entity_id
}

denormilise_entities :: proc(entities: ^map[EntityId]Entity, systems: map[typeid]proc(^Query)) -> map[typeid]Query {
    queries := map[typeid]Query {}

    for data_type in systems {
        entity_data := [dynamic]byte {}

        for entity_id, entity in entities {
            for component in entity.components {
                if(typeid_of(type_of(component)) == data_type) {
                    component_bytes := transmute([size_of(component)]byte)component
                    append(&entity_data, ..component_bytes[:])
                }
            }
        }
        queries[data_type] = Query {
            data_type = data_type,
            data_size = size_of(data_type),

            data = entity_data[:]
        }
    }
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
            world.systems[data_type](&query)
        }
    }
}