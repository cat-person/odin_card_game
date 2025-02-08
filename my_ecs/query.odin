package my_ecs

import "core:log"

Query :: map[EntityId][dynamic]byte

add_system :: proc{
    add_system1,
    add_system2
}

handle_query :: proc{
    handle_query1,
    handle_query2
}

add_system1 :: proc(world: ^World, data_type: typeid, system: proc(^World, ^Query)) {
    if len(world.systems[data_type]) == 0 {
        world.systems[data_type] = [dynamic]proc(^World, ^Query){ system }
    } else {
        append(&world.systems[data_type], system)
    }
}

handle_query1 :: proc(world: ^World, query: ^Query, $T: typeid, logic: proc(^World, EntityId, T)) {
    bytes : [size_of(T)]byte
    for entity_id, data in query {
        for byte_idx in 0..<size_of(T) {
            bytes[byte_idx] = data[byte_idx]
        }
        logic(world, entity_id, transmute(T)bytes)
    }
}

add_system2 :: proc(world: ^World, data_type1, data_type2: typeid, system: proc(^World, ^Query)) {
    composite_type := [?]typeid{data_type1, data_type2}
    if len(world.systems[composite_type]) == 0 {
        world.systems[composite_type] = [dynamic]proc(^World, ^Query){ system }
    } else {
        append(&world.systems[composite_type], system)
    }
}

handle_query2 :: proc(world: ^World, query: ^Query, $T1, $T2: typeid, logic: proc(^World, EntityId, T1, T2)) {

    bytes1 : [size_of(T1)]byte
    bytes2 : [size_of(T2)]byte

    for entity_id, data in query {

        for byte_idx in 0..<size_of(T1) {
            bytes1[byte_idx] = data[byte_idx]
        }
        for byte_idx in 0..<size_of(T2) {
            bytes2[byte_idx] = data[size_of(T1) + byte_idx]
        }
//        log.error("handle_query2 query", transmute(T1)bytes1, transmute(T2)bytes2)
        logic(world, entity_id, transmute(T1)bytes1, transmute(T2)bytes2)
    }
}