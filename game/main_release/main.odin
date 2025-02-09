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
	ecs.add_entity(&world, Kind("Human"), PawCount(2))

	ecs.add_system(&world, PawCount, put_on_shoes)
	ecs.add_system(&world, Kind, print_kinds)
	ecs.add_system(&world, Name, hello_username)
	ecs.add_system(&world, Kind, Name, hello_kind_and_name)
	ecs.add_system(&world, Name, rename)

	ecs.add_event_handler(&world, ChangeName, change_name_handler)

	ecs.update_world(&world)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8

hello_username :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(world, query, Name, proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
		log.error("hello", name)
	})
}

rename :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(world, query, Name, proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
		log.error("rename", name)
		if(name == "Octopus") {
			ecs.add_event(world, entity_id, ChangeName { new_name = Name("Pupus") })
		}
	})
}

print_kinds :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(world, query, Kind, proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind) {
		log.error("print kinds = ", kind)
	})
}

put_on_shoes :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(world, query, PawCount, proc(world: ^ecs.World, entity_id: ecs.EntityId, paw_count: PawCount) {
		log.error("put_on_shoes paw_count = ", paw_count)
		for paw_idx in 0..<paw_count {
		}
	})
}

hello_kind_and_name :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(world, query, Kind, Name, proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind, name: Name) {
		log.error("hello kind/name", kind, name)
	})
}

change_name_handler :: proc(world: ^ecs.World, entity_id: ecs.EntityId, events: []any) {
//	for event in events {
//		change_name := transmute(ChangeName)event
		log.error("change_name_handler")
//	}
}

ChangeName :: struct {
	new_name: Name
}
