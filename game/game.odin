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

PixelWindowHeight :: 180

GameMemory :: struct {	
	player_pos: Vec2,
	some_number: int,
}

g_mem: ^GameMemory

model: rl.Model

game_camera :: proc() -> rl.Camera3D {
	return {
		position = { 0.0, 0.2, -0.2 },
		target = { 0.0, 0.0, 0.0},
		up = { 0.0, 1.0, 0.0 },
		fovy = 30,
		// projection = rl.CAMERA_PERSPECTIVE,
	}
}

ui_camera :: proc() -> rl.Camera2D {
	return {
		zoom = f32(rl.GetScreenHeight())/PixelWindowHeight,
	}
}

update :: proc() {
	input: Vec2

	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
		input.y -= 1
	}
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
		input.y += 1
	}
	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
		input.x -= 1
	}
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
		input.x += 1
	}

	input = linalg.normalize0(input)
	g_mem.player_pos += input * rl.GetFrameTime() * 100
	g_mem.some_number += 1
}

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.BeginMode3D(game_camera());
		rl.DrawModel(model, { 0.0, 0.0, 0.0 }, 1.0, rl.RED);   // Draw 3d model with texture
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
	g_mem = new(GameMemory)

	g_mem^ = GameMemory {
		some_number = 100,
	}

	model = rl.LoadModel("game/assets/models/card.obj")

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
	return size_of(GameMemory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
	g_mem = (^GameMemory)(mem)
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}