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

camera: rl.Camera
model: rl.Model

main :: proc() {
	context.logger = log.create_console_logger()
	world := ecs.World {
		entities = {
			ecs.EntityId(0) = ecs.Entity {
				typeid_of(Name) = Name("Lucky"),
				typeid_of(Kind) = Kind("Gato"),
				typeid_of(Position) = Position{100, 100},
				typeid_of(PawCount) = PawCount(4),
			},
			ecs.EntityId(1) = ecs.Entity {
				typeid_of(Card) = Card("Octopus"),
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
			// [2]typeid{typeid_of(Name), typeid_of(Position)} = {draw_username_with_position},
			[2]typeid{typeid_of(Card), typeid_of(Position)} = {draw_card},
		},
	}

	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "MAIN")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(10)
	rl.SetExitKey(rl.KeyboardKey.SPACE)

	camera: rl.Camera3D
	camera.position = {5, 5, 5} // Move closer to origin
	camera.target = {0, 0, 0} // Look at origin where model is drawn
	camera.up = {0, 1, 0} // Y-up (raylib default)
	camera.fovy = 45.0 // Standard field of view
	camera.projection = .PERSPECTIVE

	// Load model with error checking
	model := rl.LoadModel("game/assets/models/card.glb")
	defer rl.UnloadModel(model)

	for !rl.WindowShouldClose() {
		rl.UpdateCamera(&camera, .ORBITAL) // Allow orbiting with mouse
		rl.BeginDrawing()
		rl.ClearBackground(rl.RED)
		rl.DrawModel(model, {0.0, 0.0, 0.0}, 100000000000.0, rl.WHITE) // Render at origin, scale 1.0
		// ecs.update_world(&world)
		rl.EndDrawing()
	}

	free_all(context.temp_allocator)
}

Card :: distinct string
Name :: distinct string
Kind :: distinct string
PawCount :: distinct u8
Position :: distinct [2]i32

// draw_username :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Name,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name) {
// 			// log.info("Draw username AAAAA")
// 			// rl.BeginDrawing()
// 			// rl.ClearBackground(rl.RAYWHITE)
// 			// name := fmt.tprintf("%s", name)
// 			rl.DrawText("AAAA", 100, 100, 20, rl.BLACK)
// 			// ecs.update_world(world)
// 			// rl.EndDrawing()
// 		},
// 	)
// }


// draw_username_with_position :: proc(world: ^ecs.World, query: ^ecs.Query) {
// 	ecs.handle_query(
// 		world,
// 		query,
// 		Name,
// 		Position,
// 		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Name, position: Position) {
// 			log.info("draw_username_with_position position", position)
// 			// rl.BeginDrawing()
// 			// rl.ClearBackground(rl.RAYWHITE)
// 			// name := fmt.tprintf("%s", name)
// 			rl.DrawText("BBBB", position.x, position.y, 20, rl.RED)
// 			// ecs.update_world(world)
// 			// rl.EndDrawing()
// 		},
// 	)
// }

draw_card :: proc(world: ^ecs.World, query: ^ecs.Query) {
	ecs.handle_query(
		world,
		query,
		Card,
		Position,
		proc(world: ^ecs.World, entity_id: ecs.EntityId, name: Card, position: Position) {
			log.info("draw_card", position)
			// rl.BeginDrawing()
			// rl.ClearBackground(rl.RAYWHITE)
			// name := fmt.tprintf("%s", name)

			rl.BeginMode3D(camera)
			rl.DrawModel(model, {0.0, 0.0, 0.0}, 100000000000.0, rl.WHITE) // Render at origin, scale 1.0
			// Optional: Ground grid for reference
			rl.EndMode3D()
			// ecs.update_world(world)
			// rl.EndDrawing()
		},
	)
}
