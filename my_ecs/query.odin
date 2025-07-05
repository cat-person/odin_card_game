#+feature dynamic-literals
package my_ecs

import "core:log"

Query :: map[EntityId][dynamic]byte // refactor dynamic

handle_query :: proc {
	handle_query1,
	handle_query2,
}

construct_query :: proc(world: ^World) -> Query {
	result: Query
	key: SystemKey
	if len(world.systems) > 0 {
		for system_key in world.systems { 	// entries.first
			key = system_key
			break
		}
		result = Query{}
		for entity_key in world.entities {
			result[entity_key] = [dynamic]byte{} // world.entities[entity_key])
		}

		log.info("Constructed query for key:", key, "with the result", result)
	} else {
		log.info("No systems has been found chill for now")
	}
	return result
}

pack_to_bytes :: proc(components: map[typeid]any) -> [dynamic]byte {
	result := [dynamic]byte{}
	return result
}
