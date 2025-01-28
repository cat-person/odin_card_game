package main_release

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"
import "core:bytes"
import "core:reflect"

import ecs "../../my_ecs"

main :: proc() {
	context.logger = log.create_console_logger()
	query := ecs.Query {
		data_type = Name,
		data_size = size_of(Name),
		data = transmute([]byte) []Name {
			Name("Johny"),
			Name("Beth"),
		}
	}
	hello_username(&query)
}



hello_username :: proc(query: ^ecs.Query) {
	ecs.handle_query(query, Name, proc(name: Name) {
		log.error("Hello", name)
	})
}

Name :: distinct string