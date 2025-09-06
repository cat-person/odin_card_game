package my_ecs

import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:reflect"

EntityId :: distinct u16

Entity :: map[typeid]any // Map of components

// add_entity :: proc(world: ^World, components: ..any) -> EntityId {
// 	component_map := map[typeid]any{}
// 	entity_id := calc_entity_id(world)

// 	for component in components {
// 		component_map[component.id] = component
// 	}

// 	world.entities[entity_id] = Entity {
// 		components = component_map,
// 	}
// 	log.info(
// 		"Entity {",
// 		component_map,
// 		"} was added now there are",
// 		len(world.entities),
// 		"entities in the world",
// 	)
// 	return entity_id
// }

// create_entity :: proc(components: map[typeid]any) -> Entity {
// 	return Entity{components}
// }

calc_entity_id :: proc(world: ^World) -> EntityId {
	return EntityId(len(world.entities))
}
