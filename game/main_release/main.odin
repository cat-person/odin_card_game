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
//	ecs.add_entity(&world, {
//		Name = transmute([]byte)Name("Johny"),
//		Kind = transmute([]byte)Kind("Doggo"),
//		PawCount = transmute([]byte)PawCount(4),
//	})
	ecs.add_entity(&world, PawCount, PawCount(4))
	ecs.add_entity(&world, Name, Name("Gravitsapa"))
	ecs.add_entity(&world, Kind, Kind("AAAAA"))

	ecs.update_world(&world)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u128

Composite :: struct {
	id: Name,
	sound: Kind,
	paw_count: PawCount
}

hello_username :: proc(name_query: ^ecs.Query) {
	log.error("hello_username name_query = ", name_query)
	ecs.handle_query(name_query, Name, proc(name: Name) {
		log.error("hello_username name", name)
	})
}
