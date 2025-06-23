#+feature dynamic-literals
package my_ecs

import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:reflect"

World :: struct {
	entities:          map[EntityId]Entity,
	components:        map[ComponentKey]Query,
	systems:           map[ComponentKey][dynamic]proc(_: ^World, _: ^Query), // map event type to
	event_handlers:    map[typeid]proc(_: ^World, _: EntityId, _: []any),
	mutation_handlers: map[typeid]proc(_: ^World, _: EntityId, _: []any),
}

ComponentKey :: union {
	typeid,
	[2]typeid,
}

create_world :: proc() -> World {
	return World{}
}

add_entity :: proc(world: ^World, components: ..any) -> EntityId {
	component_map := map[typeid][]byte{}
	for component in components {
		component_size := reflect.type_info_base(type_info_of(component.id)).size
		component_bytes := make([]byte, component_size)
		mem.copy(raw_data(component_bytes), component.data, component_size)
		component_map[component.id] = component_bytes
	}

	entity_id := calc_entity_id(world)
	world.entities[entity_id] = Entity {
		id         = entity_id,
		components = component_map,
	}
	return entity_id
}

add_event_handler :: proc(
	world: ^World,
	$TEvent: typeid,
	event_handler: proc(world: ^World, entity_id: EntityId, events: []any),
) {
	world.event_handlers[TEvent] = event_handler
}

handle_events :: proc(world: ^World) {
	// log.error("handle_events world", world)
	// for rename_me_event_id, event_handler in world.event_handlers {
	// 	log.error("handle_events event_handler", event_handler)
	// 	for event_id, event_list in world.events {
	// 		log.error("handle_events event_id", event_id)
	// 		event_handler(world, event_id.entity_id, event_list[:])
	// 	}
	// }

	// delete(world.events)
}

update_world :: proc(world: ^World) {
	components := denormilise_entities(&world.entities, world.systems)

	// for event_key in events {
	// 	log.error("update_world event_key", event_key)
	// }
}

EventId :: struct {
	entity_id:  EntityId,
	evnet_type: typeid,
}
