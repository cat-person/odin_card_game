#+feature dynamic-literals
package my_ecs

import "core:log"
import "core:mem"

Query :: map[EntityId][dynamic]byte // refactor dynamic

handle_query :: proc {
	handle_query1,
	handle_query2,
}

construct_query :: proc(world: ^World, key: SystemKey) -> Query {
	result: Query
	if len(world.systems) > 0 {
		result = Query{}

		for entity_key, entity in world.entities {
			should_be_in_query, data := pack_to_bytes(entity.components, key)
			if (should_be_in_query) {
				log.info(
					"Put entity:",
					entity_key,
					"with components:",
					entity.components,
					"to query with the key:",
					key,
				)
				result[entity_key] = data
			}
		}
	} else {
		log.info("No systems has been found chill for now")
	}
	return result
}

pack_to_bytes :: proc(components: map[typeid]any, key: SystemKey) -> (bool, [dynamic]byte) {
	result := [dynamic]byte{}
	switch type in key {
	case typeid:
		{
			component, ok := components[type]
			if !ok {
				return false, [dynamic]byte{}
			} else {
				component_size := type_info_of(type).size
				for byte in mem.byte_slice(component.data, type_info_of(type).size) {
					append(&result, byte)
				}

				log.info("component", component)
				log.info("type_info_of(type).size", type_info_of(type).size)
			}
		}
	case [2]typeid:
		{

			for component_type in type {
				component, ok := components[component_type]
				if !ok {
					return false, [dynamic]byte{}
				} else {
					component_size := type_info_of(component_type).size
					for byte in mem.byte_slice(component.data, type_info_of(component_type).size) {
						append(&result, byte)
					}

					log.info(
						"component",
						component,
						"type_info_of(type).size",
						type_info_of(component_type).size,
					)
				}
			}
		}
	}
	return true, result
}
