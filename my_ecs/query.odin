package my_ecs

Query :: struct {
    data_type: typeid,
    data_size: u16,

    data: []byte,
}

handle_query :: proc(query: ^Query, $T: typeid, logic: proc(T)) {
    for data in read_all(query, T) {
        logic(data)
    }
}

read_all :: proc(query: ^Query, $T: typeid) -> []T {
    return transmute([]T)query.data
}