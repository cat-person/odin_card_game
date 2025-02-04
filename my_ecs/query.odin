package my_ecs

import "core:log"

Query :: struct {
    data_type: ComponentKey,
    data: []byte,
}

add_system :: proc{
    add_system1,
    add_system2
}

handle_query :: proc{
    handle_query1,
    handle_query2
}

add_system1 :: proc(world: ^World, data_type: typeid, system: proc(^Query)) {
    world.systems[data_type] = system
}

handle_query1 :: proc(query: ^Query, $T: typeid, logic: proc(T)) {
    data_count := len(query.data) / size_of(T)
    result := make([]T, data_count)
    bytes : [size_of(T)]byte
    for data_idx in 0..<data_count {
        for byte_idx in 0..<size_of(T) {
            bytes[byte_idx] = query.data[data_idx * size_of(T) + byte_idx]
        }
        logic(transmute(T)(bytes))
    }
}

add_system2 :: proc(world: ^World, data_type1, data_type2: typeid, system: proc(^Query)) {
    log.error("typeid", )
    world.systems[[?]typeid{data_type1, data_type2}] = system
}

handle_query2 :: proc(query: ^Query, $T1, $T2: typeid, logic: proc(T1, T2)) {
    data_size := size_of(T1) + size_of(T2)
    data_count := len(query.data) / data_size

    bytes1 : [size_of(T1)]byte
    bytes2 : [size_of(T2)]byte

    for data_idx in 0..<data_count {
        for byte_idx in 0..<size_of(T1) {
            bytes1[byte_idx] = query.data[data_idx * data_size + byte_idx]
        }
        for byte_idx in 0..<size_of(T2) {
            bytes2[byte_idx] = query.data[data_idx * data_size + size_of(T1) + byte_idx]
        }
        logic(transmute(T1)bytes1, transmute(T2)bytes2)
    }
}