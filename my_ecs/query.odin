package my_ecs

import "core:log"

Query :: struct {
    data_type: typeid,
    data: []byte,
}

handle_query :: proc(query: ^Query, $T: typeid, logic: proc(T)) {
    for data in read_all(query, T) {
        logic(data)
    }
}

read_all :: proc(query: ^Query, $T: typeid) -> []T {
    data_count := len(query.data) / size_of(T)
    result := make([]T, data_count)
    bytes : [size_of(T)]byte
    for data_idx in 0..<data_count {
        for byte_idx in 0..<size_of(T) {
            bytes[byte_idx] = query.data[data_idx * size_of(T) + byte_idx]
        }
        result[data_idx] = transmute(T)(bytes)
    }
    return result
}