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


EventId :: struct {
	entity_id:  EntityId,
	evnet_type: typeid,
}

create_world :: proc() -> World {
	return World{}
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
	log.info("Update world")
	for system_collection_key in world.systems {
		log.info("Runing systems by key", system_collection_key)
		for system in world.systems[system_collection_key] {
			log.info("Run system", system)
		}
	}
}
