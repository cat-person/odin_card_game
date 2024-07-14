package game

import "core:math/linalg"
import "core:fmt"
import rl "vendor:raylib"

import "entity"
import "utils"
import "ecs"

main_screen_ent: ecs.Entity
card_entity: ecs.Entity
card_obj := rl.LoadModel("/resources/models/card.obj")

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
	
	card_entity = ecs.create_entity(world)
	ecs.add_component(world, card_entity, card_obj)
	ecs.add_component(world, card_entity, rl.Vector3{
		0.0, 0.0, 0.0
	})
}

@(export)
update :: proc(world: ^ecs.Context) -> bool {
	return render(world)
}

render :: proc(world: ^ecs.Context) -> bool {

	// get camera
	camera, camera_error := ecs.get_component(world, main_screen_ent, rl.Camera3D)
	card, _ := ecs.get_component(world, card_entity, rl.Model)
	// position, position_error := ecs.get_component(world, card_entity, rl.Vector3)

	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
		rl.BeginMode3D(camera^);
			rl.DrawModel(card_obj, {0.0, 0.0, 0.0}, 1.0, rl.WHITE);
			rl.DrawGrid(10, 0.1);
		rl.EndMode3D();
	rl.EndDrawing()

	return !rl.WindowShouldClose()
}



@(export)
shutdown_game :: proc(world: ^ecs.Context) { 
	ecs.deinit_ecs(world)
}

@(export)
shutdown_window :: proc(world: ^ecs.Context) {
	rl.CloseWindow()
}