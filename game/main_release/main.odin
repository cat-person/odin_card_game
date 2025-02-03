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

	world := ecs.create_world()

	ecs.add_entity(&world, Name("Lucky"), Kind("Gato"), PawCount(4))
	ecs.add_entity(&world, Name("Octopus"), Kind("Octocat"), PawCount(8))
	ecs.add_entity(&world, Name("George"), Kind("Human"), PawCount(2))

	ecs.add_system(&world, PawCount, put_on_shoes)
	ecs.add_system(&world, Kind, print_kinds)
	ecs.add_system(&world, Name, hello_username)
	ecs.add_system(&world, Kind, Name, hello_kind_and_name)

	ecs.update_world(&world)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8


hello_username :: proc(name_query: ^ecs.Query) {
	ecs.handle_query(name_query, Name, proc(name: Name) {
		log.error("hello", name)
	})
}

print_kinds :: proc(query: ^ecs.Query) {
	ecs.handle_query(query, Kind, proc(kind: Kind) {
		log.error("print kinds = ", kind)
	})
}

put_on_shoes :: proc(query: ^ecs.Query) {
	ecs.handle_query(query, PawCount, proc(paw_count: PawCount) {
		log.error("put_on_shoes paw_count = ", paw_count)
		for paw_idx in 0..<paw_count {
			//log.error("put_on_shoe on the paw #", paw_idx + 1)
		}
	})
}

hello_kind_and_name :: proc(query: ^ecs.Query) {
	ecs.handle_query(query, Kind, Name, proc(kind: Kind, name: Name) {
		log.error("hello_username", kind, name)
	})
}
