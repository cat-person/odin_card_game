#+feature dynamic-literals
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
	world := ecs.World {
		entities = {
			ecs.EntityId(0) = ecs.Entity {
				typeid_of(Name) = Name("Lucky"),
				typeid_of(Name) = Name("Lucky"),
				typeid_of(Kind) = Kind("Gato"),
				typeid_of(Position) = Position{100, 100},
				typeid_of(PawCount) = PawCount(4),
			},
			ecs.EntityId(1) = ecs.Entity {
				typeid_of(Name) = Name("Octopus"),
				typeid_of(Kind) = Kind("Octocat"),
				typeid_of(Position) = Position{200, 200},
				typeid_of(PawCount) = PawCount(8),
			},
			ecs.EntityId(2) = ecs.Entity {
				typeid_of(Name) = Name("George"),
				typeid_of(Kind) = Kind("Human"),
				typeid_of(Position) = Position{300, 300},
				typeid_of(PawCount) = PawCount(2),
			},
			ecs.EntityId(3) = ecs.Entity {
				typeid_of(Kind) = Kind("Human"),
				typeid_of(PawCount) = PawCount(2),
			},
			ecs.EntityId(4) = ecs.Entity {
				typeid_of(Name) = Name("Mefisto"),
				typeid_of(Kind) = Kind("Snail"),
			},
			ecs.EntityId(5) = ecs.Entity{typeid_of(Kind) = Kind("Worm")},
		},
		systems = {
			// typeid_of(Name) = {draw_username},
			[2]typeid{typeid_of(Name), typeid_of(Position)} = {draw_username_with_position},
		},
	}

	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "MAIN")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(10)
	rl.SetExitKey(rl.KeyboardKey.SPACE)


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)
		// rl.DrawText("Press SPACE to exit", 100, 100, 20, rl.BLACK)
		ecs.update_world(&world)
		rl.EndDrawing()
	}

	free_all(context.temp_allocator)
}

Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8
Position :: distinct [2]i32

draw_username :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Name,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
			// log.info("Draw username AAAAA")
			// rl.BeginDrawing()
			// rl.ClearBackground(rl.RAYWHITE)
			// name := fmt.tprintf("%s", name)
			rl.DrawText("AAAA", 100, 100, 20, rl.BLACK)
			// ecs.update_world(world)
			// rl.EndDrawing()
		},
	)
}


draw_username_with_position :: proc(world: ^ecs.World, query: ^ecs.Query) {
	log.info("draw_username_with_position")
	ecs.handle_query(
		world,
		query,
		Name,
		Position,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name, position: Position) {
			log.info("draw_username_with_position position", position)
			// rl.BeginDrawing()
			// rl.ClearBackground(rl.RAYWHITE)
			// name := fmt.tprintf("%s", name)
			rl.DrawText("BBBB", position.x, position.y, 20, rl.RED)
			// ecs.update_world(world)
			// rl.EndDrawing()
		},
	)
}

// rename :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Name,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
// 			log.error("rename", name)
// 			if (name == "Octopus") {
// 				// ecs.add_event(world, entity_id, ChangeName{new_name = Name("Pupus")})
// 			}
// 		},
// 	)
// }

// print_kinds :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Kind,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind) {
// 			// log.error("print kinds = ", kind)
// 		},
// 	)
// }

// put_on_shoes :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		PawCount,
// 		Name,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, paw_count: PawCount, name: Name) {
// 			log.error("put_on_shoes on", name, "with", paw_count, "paws")
// 			for paw_idx in 0 ..< paw_count {
// 				// log.error("shoe has been put on paw", paw_idx + 1)
// 			}
// 		},
// 	)
// }

// hello_kind_and_name :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Kind,
// 		Name,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind, name: Name) {
// 			log.error("hello kind/name", kind, name)
// 		},
// 	)
// }

// hello_name_and_kind :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Name,
// 		Kind,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name, kind: Kind) {
// 			log.error("hello name/kind", name, kind)
// 		},
// 	)
// }

// kill_all_humans :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Kind,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, kind: Kind) {
// 			if kind == Kind("Human") {
// 				delete_key(&world.entities, entity_id)
// 				log.error("Pesky human was killed")
// 			} else {
// 				log.error(kind, "was left alive")
// 			}
// 		},
// 	)
// }
