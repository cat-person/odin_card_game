// This file is compiled as part of the `odin.dll` file. It contains the
// procs that `game.exe` will call, such as:
//
// game_init: Sets up the game state
// game_update: Run once per frame
// game_shutdown: Shuts down game and frees memory
// game_memory: Run just before a hot reload, so game.exe has a pointer to the
//		game's memory.
// game_hot_reloaded: Run after a hot reload so that the `g_mem` global variable
//		can be set to whatever pointer it was in the old DLL.

package game

import "core:math/linalg"
import "core:fmt"
import rl "vendor:raylib"

import "entity"
import "utils"

PixelWindowHeight :: 180

g_mem: ^entity.World

mouse_point: rl.Vector3

game_camera := rl.Camera3D {
	position = { 0.0, 0.4, -0.4 } ,
	target = { 0.0, 0.0, 0.0 },
	up = { 0.0, 1.0, 0.0 },
	fovy = 30
}

update :: proc() {
	input: rl.Vector3
	mouse_ray := rl.GetMouseRay(rl.GetMousePosition(), game_camera)

	for &card in g_mem.cards {
		if coll := rl.GetRayCollisionMesh(mouse_ray, card.model.meshes[0], rl.MatrixTranslate(
			card.position.x,
			card.position.y,
			card.position.z)); coll.hit {
				
				if (rl.IsMouseButtonDown(.LEFT)){
					if(mouse_point != {0, 0, 0}) {
						card.color = rl.LIME
						card.position += coll.point - mouse_point
					}
					mouse_point = coll.point
				} else {
					mouse_point = {0,0,0}
					card.color = rl.GREEN
				}
			} else {
				card.color = rl.YELLOW
			}
	}

	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		input.z += 1
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
		input.z -= 1
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		input.x += 1
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		input.x -= 1
	}

	game_camera.position += input / 1000
	game_camera.target += input / 1000
}



draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
		rl.BeginMode3D(game_camera);
			for card in g_mem.cards {
				rl.DrawModel(card.model, card.position, 1.0, card.color);	
			}
			rl.DrawGrid(10, 0.1);
		rl.EndMode3D();
	rl.EndDrawing()
}

@(export)
game_update :: proc() -> bool {
	update()
	draw()
	return !rl.WindowShouldClose()
}

@(export)
game_init_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(1280, 720, "Odin + Raylib + Hot Reload template!")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(500)
}

@(export)
game_init :: proc() {
	g_mem = new(entity.World)

	g_mem^ = entity.World {
		cards = {
			entity.createCard(rl.LoadModel("game/assets/models/card.obj"))
		} 
	}
	game_hot_reloaded(g_mem)
}

@(export)
game_shutdown :: proc() { 
	free(g_mem)
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseWindow()
}

@(export)
game_memory :: proc() -> rawptr {
	return g_mem
}

@(export)
game_memory_size :: proc() -> int {
	return size_of(entity.World)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
	g_mem = (^entity.World)(mem)
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}