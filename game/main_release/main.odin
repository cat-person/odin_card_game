package main_release

import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:reflect"

import rl "vendor:raylib"

import game ".."
import ecs "../../my_ecs"

main :: proc() {
	context.logger = log.create_console_logger()

	world := ecs.create_world()

	// camera_entity := ecs.add_entity(
	// 	&world,
	// 	rl.Camera3D,
	// 	rl.Camera3D {
	// 		position = {0.0, 0.4, -0.4},
	// 		target = {0.0, 0.0, 0.0},
	// 		up = {0.0, 1.0, 0.0},
	// 		fovy = 30,
	// 	},
	// )

	ecs.add_entity(&world, Name("Lucky"), Kind("Gato"), PawCount(4))
	ecs.add_entity(&world, Name("Octopus"), Kind("Octocat"), PawCount(8))
	ecs.add_entity(&world, Name("George"), Kind("Human"), PawCount(2))
	ecs.add_entity(&world, Kind("Human"), PawCount(2))
	ecs.add_entity(&world, Kind("Snail"), Name("Mefisto"))
	ecs.add_entity(&world, Kind("Worm"))

	// ecs.add_system(&world, Kind, Name, hello_kind_and_name)
	// ecs.add_system(&world, Name, Kind, hello_name_and_kind)
	// ecs.add_system(&world, Name, PawCount, put_on_shoes)
	ecs.add_system(&world, Kind, kill_all_humans)

	ecs.update_world(&world)
	ecs.update_world(&world)

	game_create()
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8

hello_username :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Name,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
			log.error("hello", name)
		},
	)
}

rename :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Name,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
			log.error("rename", name)
			if (name == "Octopus") {
				// ecs.add_event(world, entity_id, ChangeName{new_name = Name("Pupus")})
			}
		},
	)
}

print_kinds :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Kind,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind) {
			// log.error("print kinds = ", kind)
		},
	)
}

put_on_shoes :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		PawCount,
		Name,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, paw_count: PawCount, name: Name) {
			log.error("put_on_shoes on", name, "with", paw_count, "paws")
			for paw_idx in 0 ..< paw_count {
				// log.error("shoe has been put on paw", paw_idx + 1)
			}
		},
	)
}

hello_kind_and_name :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Kind,
		Name,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind, name: Name) {
			log.error("hello kind/name", kind, name)
		},
	)
}

hello_name_and_kind :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Name,
		Kind,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name, kind: Kind) {
			log.error("hello name/kind", name, kind)
		},
	)
}

kill_all_humans :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Kind,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind) {
			if kind == Kind("Human") {
				delete_key(&world.entities, entity_id)
				log.error("Pesky human was killed")
			} else {
				log.error(kind, "was left alive")
			}
		},
	)
}

kill_human_handler :: proc(world: ^ecs.World, entity_id: ecs.EntityId, events: []any) {
	//	for event in events {
	//		change_name := transmute(ChangeName)event
	log.error("change_name_handler")
	//	}
}

ChangeName :: struct {
	new_name: Name,
}

KillHuman :: struct {
	entity_id: ecs.EntityId,
}

game_create :: proc() {
	game.game_init_window()
	game.game_init()

	for game.game_should_run() {
		game.game_update()
	}

	free_all(context.temp_allocator)
	game.game_shutdown()
	game.game_shutdown_window()
}
