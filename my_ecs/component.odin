package my_ecs

import "core:log"
import "core:reflect"

denormilise_entities :: proc(
	entities: ^map[EntityId]Entity,
	systems: map[ComponentKey][dynamic]proc(_: ^World, _: ^Query),
) -> map[ComponentKey]Query {
	queries := map[ComponentKey]Query{}

	for component_key in systems {
		switch type in component_key {
		case typeid:
			{
				queries[component_key] = extract_query_single(entities, type)
			}
		case [2]typeid:
			{
				queries[component_key] = extract_query_multiple(entities, type)
			}
		}
	}
	return queries
}

extract_query_single :: proc(entities: ^map[EntityId]Entity, data_type: typeid) -> Query {
	result := make(Query)

	for entity_id, entity in entities {
		if (data_type in entity.components) {
			query_data := make([dynamic]byte)
			component_data := entity.components[data_type]
			for data_byte_idx in 0 ..< len(component_data) {
				append(&query_data, component_data[data_byte_idx])
			}
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
					append(&query_data, component_data[data_byte_idx])
				}
			}

			result[entity_id] = query_data
		}
	}
	return result
}
