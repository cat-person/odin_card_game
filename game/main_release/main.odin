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

	world := ecs.create_world()

	ecs.add_system(&world, Name, hello_username)
	ecs.add_entity(&world, []any{
		Name("Johny"),
		Kind("Doggo"),
		PawCount(4),
	})
	ecs.add_entity(&world, []any{
		Name("Lucky"),
		Kind("Gato"),
		PawCount(4),
	})

	ecs.update_world(&world)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8

Composite :: struct {
	id: Name,
	sound: Kind,
	paw_count: PawCount
}


hello_username :: proc(name_query: ^ecs.Query) {
	ecs.handle_query(name_query, Name, proc(name: Name) {
		log.error("Hello", name)
	})
}
