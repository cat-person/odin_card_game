package game

import "core:math/linalg"
import "core:fmt"
import rl "vendor:raylib"

// import "entity"
// import "ecs"
import "../my_ecs"

card_obj : rl.Model 

// will work only with ecs

Game :: struct {
	name: cstring,
	world: my_ecs.World,
	create : proc(game: ^Game),
	update : proc(game: ^Game) -> bool,
	destroy : proc(game: ^Game),
}

new_game :: proc() -> Game {
	return Game {
		name = "Odin card game",
		world = my_ecs.new_world,
		create = game_create,
		update = game_update,
		destroy = game_destroy,
	}
}

game_create :: proc(game: ^Game) {
	// should also be in ecs
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(1280, 720, game.name)
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(60)

	game.world.init(&game.world)

	camera_entity := my_ecs.world_add_entity(&game.world, rl.Camera3D, &rl.Camera3D {
		position = { 0.0, 0.4, -0.4 } ,
		target = { 0.0, 0.0, 0.0 },
		up = { 0.0, 1.0, 0.0 },
		fovy = 30
	})

	my_ecs.world_add_system(&game.world, rl.Camera3D, render_camera)
}

game_update :: proc(game: ^Game) -> bool {
	return game_render(game)
}

render_camera :: proc(camera: ^rl.Camera3D) {
	rl.BeginMode3D(camera^);
		rl.DrawGrid(10, 0.1);
	rl.EndMode3D();
}

game_render :: proc(game: ^Game) -> bool {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
		
	rl.EndDrawing()

	return !rl.WindowShouldClose()
}

game_destroy :: proc(game: ^Game) { 
	rl.CloseWindow()
	// world.destroy()
	// free(world)
}