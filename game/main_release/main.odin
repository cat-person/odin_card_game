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
//	query := ecs.Query {
//		data_type = Name,
//		data_size = size_of(Name),
//		data = transmute([]byte) []Name {
//			Name("Johny"),
//			Name("Beth"),
//		}
//	}

	world := ecs.create_world()

//	ecs.add_entity(&world, {
//		Name = transmute([]byte)Name("Johny"),
//		Kind = transmute([]byte)Kind("Doggo"),
//		PawCount = transmute([]byte)PawCount(4),
//	})
	ecs.add_entity(&world, {PawCount(4)})
	ecs.add_entity(&world, {PawCount(8)})
	ecs.add_entity(&world, {PawCount(2)})
//	ecs.add_entity(&world, Name, Name("Gravitsapa"))
//	ecs.add_entity(&world, Kind, Kind("AAAAA"))
//	ecs.add_system(&world, Name, hello_username)

	ecs.add_system(&world, PawCount, put_on_shoes)
//	ecs.add_system(&world, Kind, print_kinds)

	ecs.update_world(&world)
}

//Name :: distinct string
//Kind :: distinct string
PawCount :: distinct u8

//Composite :: struct {
//	id: Name,
//	sound: Kind,
//	paw_count: PawCount
//}

//hello_username :: proc(name_query: ^ecs.Query) {
//	ecs.handle_query(name_query, Name, proc(name: Name) {
//		log.error("hello_username name", name)
//	})
//}

put_on_shoes :: proc(query: ^ecs.Query) {
	log.error("put_on_shoes query = ", query)
	ecs.handle_query(query, PawCount, proc(paw_count: PawCount) {
		log.error("put_on_shoes paw_count = ", paw_count)
		for paw_idx in 0..<paw_count {
			log.error("put_on_shoe on the paw #", paw_idx + 1)
		}
	})
}
//
//print_kinds :: proc(query: ^ecs.Query) {
//	ecs.handle_query(query, Kind, proc(kind: Kind) {
//		log.error("print kinds = ", kind)
//	})
//}