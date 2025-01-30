package my_ecs

import "core:log"

Query :: struct {
    data_type: typeid,
    data_size: u16,

    data: []byte,
}

handle_query :: proc(query: ^Query, $T: typeid, logic: proc(T)) {
    log.error("handle_query read_all(query, T) = ", read_all(query, T))
//    for data in read_all(query, T) {
        logic(read_all(query, T))
//    }
}

read_all :: proc(query: ^Query, $T: typeid) -> T {
    return transmute(T)query.data
}

build_queries :: proc(entities: []Entity) {

}