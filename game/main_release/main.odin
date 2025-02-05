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
	ecs.add_system(&world, Name, rename)
	ecs.update_world(&world)

	ecs.add_event_handler(&world, ChangeName, change_name_handler)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8

hello_username :: proc(world: ^ecs.World, name_query: ^ecs.Query) {
	ecs.handle_query(name_query, Name, proc(name: Name) {
		log.error("hello", name)
	})
}

rename :: proc(world: ^ecs.World, name_query: ^ecs.Query) {
	ecs.handle_query(name_query, Name, proc(name: Name) {
		log.error("rename", name)

	})
}

print_kinds :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(query, Kind, proc(kind: Kind) {
		log.error("print kinds = ", kind)
	})
}

put_on_shoes :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(query, PawCount, proc(paw_count: PawCount) {
		log.error("put_on_shoes paw_count = ", paw_count)
		for paw_idx in 0..<paw_count {
			//log.error("put_on_shoe on the paw #", paw_idx + 1)
		}
	})
}

hello_kind_and_name :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(query, Kind, Name, proc(kind: Kind, name: Name) {
		log.error("hello kind/name", kind, name)
	})
}

change_name_handler :: proc(world: ^ecs.World, entity_id: ecs.EntityId, events: []any) {
	for event in events {
		change_name := transmute(ChangeName)event
		log.error("hello_username", change_name)
	}
}

ChangeName :: struct {
	new_name: string
}
