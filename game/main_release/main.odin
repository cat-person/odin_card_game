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


//	ecs.add_system(&world, Name, hello_username)
//	ecs.add_system(&world, PawCount, put_on_shoes)
//	ecs.add_system(&world, Kind, print_kinds)
//	ecs.add_system(&world, Kind, Name, hello_kind_and_name)
	ecs.add_system(&world, Name, rename)

	ecs.add_event_handler(&world, Rename, change_name_handler)

	ecs.update_world(&world)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8

//hello_username :: proc(query: ^ecs.Query) -> ecs.EventMap {
//	return ecs.handle_query(query, Name, proc(entity_id: ecs.EntityId, name: Name) -> ecs.Events {
//		log.error("hello", name)
//		return nil
//	})
//}

rename :: proc(query: ^ecs.Query) -> ecs.EventMap {
	return ecs.handle_query(query, Name, proc(entity_id: ecs.EntityId, name: Name) -> any {
		log.error("rename", name)
		if(name == "Octopus") {
			log.error("Octopus renamed to Pupus")
			return Rename { new_name = 42 } // <==== The hell
		}
		log.error("rename Exit", name)
		return nil
	})
}

//print_kinds :: proc(world: ^ecs.World, query: ^ecs.Query) -> map[EventKey][dynamic]any {
//	ecs.handle_query(world, query, Kind, proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind) {
//		log.error("print kinds = ", kind)
//	})
//}
//
//put_on_shoes :: proc(world: ^ecs.World, query: ^ecs.Query) -> map[EventKey][dynamic]any {
//	ecs.handle_query(world, query, PawCount, proc(world: ^ecs.World, entity_id: ecs.EntityId, paw_count: PawCount) {
//		log.error("put_on_shoes paw_count = ", paw_count)
//		for paw_idx in 0..<paw_count {
//			//log.error("put_on_shoe on the paw #", paw_idx + 1)
//		}
//	})
//}
//
//hello_kind_and_name :: proc(world: ^ecs.World, query: ^ecs.Query) -> map[EventKey][dynamic]any {
//	ecs.handle_query(world, query, Kind, Name, proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind, name: Name) {
//		log.error("hello kind/name", kind, name)
//	})
//}
//
change_name_handler :: proc(world: ^ecs.World, entity_id: ecs.EntityId, event: any) {
//		change_name := transmute(Rename)event.dat
		log.error("Change name event handled renamed ", world.entities[entity_id].components[Name], event)
//		world.entities[entity_id].components[Name]
		// = Name(change_name.new_name)
}

Rename :: struct {
	new_name: u16
}
