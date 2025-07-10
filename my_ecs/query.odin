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
	// key: SystemKey
	if len(world.systems) > 0 {
		// for system_key in world.systems { 	// entries.first
		// 	key = system_key
		// 	break
		// }
		result = Query{}

		for entity_key, entity in world.entities {

			switch type in key {
			case typeid:
				{

				}
			case [2]typeid:
				{
					should_be_in_query, data := pack_to_bytes_two(entity.components, type) // world.entities[entity_key])
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
			}
		}

		log.info("Constructed query for key:", key, "with the result", result)
	} else {
		log.info("No systems has been found chill for now")
	}
	return result
}

pack_to_bytes :: proc {
	pack_to_bytes_one,
	pack_to_bytes_two,
}

pack_to_bytes_one :: proc(components: map[typeid]any, key: typeid) -> (bool, [dynamic]byte) {
	return false, [dynamic]byte{}
}

pack_to_bytes_two :: proc(components: map[typeid]any, key: [2]typeid) -> (bool, [dynamic]byte) {

	result := [dynamic]byte{}

	for type in key {
		component, ok := components[type]
		if !ok {
			return ok, [dynamic]byte{}
		} else {
			component_size := type_info_of(type).size
			log.info("component", component)
			log.info("type_info_of(type).size", type_info_of(type).size)
			for byte in mem.byte_slice(component.data, type_info_of(type).size) {
				append(&result, byte)
			}

			log.info("component", component)
			log.info("type_info_of(type).size", type_info_of(type).size)
		}
	}

	return true, result
}
