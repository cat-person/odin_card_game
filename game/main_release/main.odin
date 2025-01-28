package main_release

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"
import "core:bytes"
import "core:reflect"

main :: proc() {
	context.logger = log.create_console_logger()
	query := Query {
		data_type = Name,
		data_size = size_of(Name),
		data = transmute([]byte) []Name {
		Name("Johny"),
		Name("Beth"),
		}
	}
	hello_username(&query)
}

handle_query :: proc(query: ^Query, $T: typeid, logic: proc(T)) {
	for data in read_all(query, T) {
		logic(data)
	}
}

hello_username :: proc(query: ^Query) {
	handle_query(query, Name, proc(name: Name) {
		log.error("Hello", name)
	})
}

Name :: distinct string

Query :: struct {
	data_type: typeid,
	data_size: u16,

	data: []byte,
}

read_all :: proc(query: ^Query, $T: typeid) -> []T {
	return transmute([]T)query.data
}