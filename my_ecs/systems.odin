#+feature dynamic-literals
package my_ecs

import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:reflect"

add_system1 :: proc(world: ^World, data_type: typeid, system: proc(_: ^World, _: ^Query)) {
	if len(world.systems[data_type]) == 0 {
		log.info(
			"New collection of systems with the key {",
			data_type,
			"} was added for system",
			system,
		)
		world.systems[data_type] = [dynamic]proc(_: ^World, _: ^Query){system}
	} else {
		log.info("System", system, "was added to collection with the key {", data_type, "}")
		append(&world.systems[data_type], system)
	}
	log.info("add_system1")
}

handle_query1 :: proc(
	world: ^World,
	query: ^Query,
	$T: typeid,
	logic: proc(_: ^World, _: EntityId, _: T),
) {
	bytes: [size_of(T)]byte
	log.info(query)
	for entity_id, data in query {
		for byte_idx in 0 ..< size_of(T) {
			bytes[byte_idx] = data[byte_idx]
		}
		log.info("Call logic")
		logic(world, entity_id, transmute(T)bytes)
	}

}

add_system2 :: proc(
	world: ^World,
	data_type1, data_type2: typeid,
	system: proc(_: ^World, _: ^Query),
) {
	composite_type: SystemKey
	if (transmute(u64)(data_type1) < transmute(u64)(data_type2)) {
		composite_type = create_component_key(data_type1, data_type2)
	} else {
		composite_type = create_component_key(data_type2, data_type1)
	}
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
	for entity_id, data in query {
		log.info("Running system", logic, "on", data)

		if (transmute(u64)(typeid_of(T1)) < transmute(u64)(typeid_of(T2))) {
			t1_data: [size_of(T1)]byte
			mem.copy(&t1_data, raw_data(data[:size_of(T1)]), size_of(T1))
			t2_data: [size_of(T2)]byte
			mem.copy(&t2_data, raw_data(data[size_of(T1):]), size_of(T2))
			t1_casted_data := transmute(T1)(t1_data)
			t2_casted_data := transmute(T2)(t2_data)
			log.info(
				"Transmuted data",
				map[typeid]any{typeid_of(T1) = t1_casted_data, typeid_of(T2) = t2_casted_data},
			)

			logic(world, entity_id, t1_casted_data, t2_casted_data)
		} else {
			t1_data: [size_of(T1)]byte
			mem.copy(&t1_data, raw_data(data[size_of(T2):]), size_of(T1))
			t2_data: [size_of(T2)]byte
			mem.copy(&t2_data, raw_data(data[:size_of(T2)]), size_of(T2))
			logic(world, entity_id, transmute(T1)(t1_data), transmute(T2)(t2_data))
		}
	}
}

add_system :: proc {
	add_system1,
	add_system2,
}
