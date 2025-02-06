package my_ecs

import "core:log"

ComponentKey :: union {
    typeid,
    [2]typeid,
    [3]typeid,
    [4]typeid,
    [5]typeid,
    [6]typeid,
}

denormilise_entities :: proc(entities: ^map[EntityId]Entity, systems: map[ComponentKey][dynamic]proc(^World, ^Query)) -> map[ComponentKey]Query {
    queries := map[ComponentKey]Query {}

    for component_key in systems {
        entity_data := make([dynamic]byte, 0, 16)

        switch type in component_key {
        case typeid:  {
            queries[component_key] = extract_query_single(entities, type)
        }
        case [2]typeid: {
            queries[component_key] = extract_query_multiple(entities, type)
        }
        case [3]typeid:
        case [4]typeid:
        case [5]typeid:
        case [6]typeid: {

        }
        }
    }

    return queries
}

extract_query_single :: proc(entities: ^map[EntityId]Entity, single_key: typeid) -> Query {
//    entity_data := make([dynamic]byte, 0, 16)
    result := make(map[EntityId][]byte)

    log.error("created single parameter query", single_key)

    for entity_id, entity in entities {
        for component_id, component_data in entity.components {
            if(component_id == single_key) {
                result[entity_id] = component_data
            }
        }
    }
    return result
}

extract_query_multiple :: proc(entities: ^map[EntityId]Entity, multiple_key: [2]typeid) -> Query {
    log.error("created multi parameter query", multiple_key)
    result := make(map[EntityId][]byte)
    entity_data := make([dynamic]byte, 0, 16)
    for entity_id, entity in entities {
        contains_all_components := true
        for data_type in multiple_key {
            if data_type in entity.components {

            } else {
                contains_all_components = false
                break
            }
        }
        if(contains_all_components) {
            for data_type in multiple_key {
                append(&entity_data, ..entity.components[data_type])

            }
            result[entity_id] = entity_data[:]
        }
    }

    return result
}
