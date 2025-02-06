package my_ecs

import "core:log"

Query :: map[EntityId][]byte

add_system :: proc{
    add_system1,
    add_system2
}

handle_query :: proc{
    handle_query1,
    handle_query2
}

add_system1 :: proc(world: ^World, data_type: typeid, system: proc(^Query) -> map[EventKey][dynamic]any) {
    if len(world.systems[data_type]) == 0 {
        world.systems[data_type] = [dynamic]proc(^Query) -> map[EventKey][dynamic]any { system }
    } else {
        append(&world.systems[data_type], system)
    }
}

handle_query1 :: proc(query: ^Query, $T: typeid, logic: proc(EntityId, T) -> map[EventKey][dynamic]any) -> map[EventKey][dynamic]any {
    bytes : [size_of(T)]byte

    result := make(map[EventKey][dynamic]any)

    for entity_id, data in query {
        for byte_idx in 0..<size_of(T) {
            bytes[byte_idx] = data[byte_idx]
        }
        logic(entity_id, transmute(T)bytes)
    }

    return result
}

add_system2 :: proc(world: ^World, data_type1, data_type2: typeid, system: proc(^Query) -> map[EventKey][dynamic]any) {
    composite_type := [?]typeid{data_type1, data_type2}
    if len(world.systems[composite_type]) == 0 {
        world.systems[composite_type] = [dynamic]proc(^Query) -> map[EventKey][dynamic]any { system }
    } else {
        append(&world.systems[composite_type], system)
    }
}

handle_query2 :: proc(query: ^Query, $T1, $T2: typeid, logic: proc(EntityId, T1, T2) -> map[EventKey][dynamic]any) -> map[EventKey][dynamic]any {

    result := make(map[EventKey][dynamic]any)

    bytes1 : [size_of(T1)]byte
    bytes2 : [size_of(T2)]byte

    for entity_id, data in query {
        for byte_idx in 0..<size_of(T1) {
            bytes1[byte_idx] = data[byte_idx]
        }
        for byte_idx in 0..<size_of(T2) {
            bytes2[byte_idx] = data[size_of(T1) + byte_idx]
        }
        logic(world, entity_id, transmute(T1)bytes1, transmute(T2)bytes2)
    }

    return result
}