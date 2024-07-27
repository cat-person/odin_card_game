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
		world = my_ecs.new_world(),
		create = game_create,
		update = game_update,
		destroy = game_destroy,
	}
}

game_create :: proc(game: ^Game) {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(1280, 720, game.name)
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(60)

	game.world.init(&game.world)

	game.world.add_entity(&game.world, "camera")
	game.world.add_entity(&game.world, "something_else")

	for entity in game.world.entity_list {
		fmt.println(entity.name)
	}

	fmt.println("AAAAAAAAA")
}

game_update :: proc(game: ^Game) -> bool {
	// world.update()
	return game_render(game)
}

game_render :: proc(game: ^Game) -> bool {
	// camera, camera_error := ecs.get_component(world, main_screen_ent, rl.Camera3D)
	// card, card_error := ecs.get_component(world, card_entity, rl.Model)
	// position, position_error := ecs.get_component(world, card_entity, rl.Vector3)

	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
		// rl.BeginMode3D(camera^);
		// 	rl.DrawModel(card^, position^, 1.0, rl.PINK);
		// 	rl.DrawGrid(10, 0.1);
		// rl.EndMode3D();
	rl.EndDrawing()

	return !rl.WindowShouldClose()
}

game_destroy :: proc(game: ^Game) { 
	rl.CloseWindow()
	// world.destroy()
	// free(world)
}