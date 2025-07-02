#+feature dynamic-literals
package my_ecs

import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:reflect"

add_system1 :: proc(world: ^World, data_type: typeid, system: proc(_: ^World, _: ^Query)) {
	// if len(world.systems[data_type]) == 0 {
	// 	world.systems[data_type] = [dynamic]proc(_: ^World, _: ^Query){ system }
	// } else {
	// 	append(&world.systems[data_type], system)
	// }
	log.info("add_system1")
}

handle_query1 :: proc(
	world: ^World,
	query: ^Query,
	$T: typeid,
	logic: proc(_: ^World, _: EntityId, _: T),
) {
	bytes: [size_of(T)]byte
	for entity_id, data in query {
		for byte_idx in 0 ..< size_of(T) {
			bytes[byte_idx] = data[byte_idx]
		}
		logic(world, entity_id, transmute(T)bytes)
	}
}

add_system2 :: proc(
	world: ^World,
	data_type1, data_type2: typeid,
	system: proc(_: ^World, _: ^Query),
) {
	composite_type := create_component_key(data_type1, data_type2)
	if len(world.systems[composite_type]) == 0 {
		log.info(
			"New collection of systems with the key {",
			composite_type,
			"} was added for system",
			system,
		)
		world.systems[composite_type] = [dynamic]proc(_: ^World, _: ^Query){system}
	} else {
		log.info("System", system, "was added to collection with the key {", composite_type, "}")
		append(&world.systems[composite_type], system)
	}
	log.info("System {", system, "} was added current system count is ", len(world.systems))
}

handle_query2 :: proc(
	world: ^World,
	query: ^Query,
	$T1, $T2: typeid,
	logic: proc(_: ^World, _: EntityId, _: T1, _: T2),
) {

	bytes1: [size_of(T1)]byte
	bytes2: [size_of(T2)]byte

	for entity_id, data in query {

		for byte_idx in 0 ..< size_of(T1) {
			bytes1[byte_idx] = data[byte_idx]
		}
		for byte_idx in 0 ..< size_of(T2) {
			bytes2[byte_idx] = data[size_of(T1) + byte_idx]
		}
		//        log.error("handle_query2 query", transmute(T1)bytes1, transmute(T2)bytes2)
		logic(world, entity_id, transmute(T1)bytes1, transmute(T2)bytes2)
	}
}

add_system :: proc {
	add_system1,
	add_system2,
}
