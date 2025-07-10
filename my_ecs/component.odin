package my_ecs

import "core:log"
import "core:reflect"
import "core:slice"

denormilise_entities :: proc(
	entities: ^map[EntityId]Entity,
	systems: map[SystemKey][dynamic]proc(_: ^World, _: ^Query),
) -> map[SystemKey]Query {
	queries := map[SystemKey]Query{}

	for component_key in systems {
		// switch type in component_key {
		// case typeid:
		// 	{
		// 		queries[component_key] = extract_query_single(entities, type)
		// 	}
		// case [2]typeid:
		// 	{
		queries[component_key] = extract_query_multiple(entities, component_key)
		// 	}
		// }
	}
	return queries
}

extract_query_single :: proc(entities: ^map[EntityId]Entity, data_type: typeid) -> Query {
	result := make(Query)

	for entity_id, entity in entities {
		if (data_type in entity.components) {
			query_data := make([dynamic]byte)
			component_data := entity.components[data_type]
			// for data_byte_idx in 0 ..< len(component_data) {
			// 	append(&query_data, component_data[data_byte_idx])
			// }
			result[entity_id] = query_data
		}
	}
	return result
}

extract_query_multiple :: proc(entities: ^map[EntityId]Entity, multiple_key: [2]typeid) -> Query {
	result := make(Query)

	for entity_id, entity in entities {
		contains_all_components := true
		for data_type in multiple_key {
			if data_type in entity.components {

			} else {
				contains_all_components = false
				break
			}
		}
		if (contains_all_components) {
			query_data := make([dynamic]byte)

			for data_type in multiple_key {
				data_size := reflect.type_info_base(type_info_of(data_type)).size
				component_data := entity.components[data_type]
				for data_byte_idx in 0 ..< data_size {
					// append(&query_data, component_data[data_byte_idx])
				}
			}

			result[entity_id] = query_data
		}
	}
	return result
}

SystemKey :: [2]typeid


create_component_key :: proc {
	create_component_key_1,
	create_component_key_2,
}

create_component_key_1 :: proc(id: typeid) -> SystemKey {
	return SystemKey(id)
}

create_component_key_2 :: proc(first: typeid, second: typeid) -> SystemKey {
	if transmute(u64)(first) < transmute(u64)(second) {
		return SystemKey([2]typeid{first, second})
	} else {
		return SystemKey([2]typeid{second, first})
	}
}
