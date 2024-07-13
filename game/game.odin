package game

import "core:math/linalg"
import "core:fmt"
import rl "vendor:raylib"

import "entity"
import "utils"
import "ecs"

main_screen_ent : ecs.Entity

@(export)
init_window :: proc(world: ^ecs.Context) {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(1280, 720, "Odin + Raylib + Hot Reload template!")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(60)

	main_screen_ent = ecs.create_entity(world)
	ecs.add_component(world, main_screen_ent, rl.Camera3D {
		position = { 0.0, 0.4, -0.4 } ,
		target = { 0.0, 0.0, 0.0 },
		up = { 0.0, 1.0, 0.0 },
		fovy = 30
	})
}

@(export)
init :: proc(world: ^ecs.Context) {
	
}

@(export)
update :: proc(world: ^ecs.Context) -> bool {
	draw(world)
	return !rl.WindowShouldClose()
}

draw :: proc(world: ^ecs.Context) {

	// get camera
	camera, error := ecs.get_component(world, main_screen_ent, rl.Camera3D)

	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
		rl.BeginMode3D(camera^);
			// for card in g_mem.cards {
			// 	rl.DrawModel(card.model, card.position, 1.0, card.color);
			// }
			// for &card, idx in g_mem.deck.cards {
			// 	card.position = g_mem.deck.position + {0, (f32)(5 - idx) * 0.002, 0} // <= should be card.height or something
			// 	rl.DrawModel(card.model, card.position, 1.0, card.color);
			// }

			rl.DrawGrid(10, 0.1);
		rl.EndMode3D();
	rl.EndDrawing()
}



@(export)
shutdown_game :: proc(world: ^ecs.Context) { 
	ecs.deinit_ecs(world)
}

@(export)
shutdown_window :: proc(world: ^ecs.Context) {
	rl.CloseWindow()
}