package game

import ecs "../my_ecs"
import "core:fmt"
import "core:math/linalg"
import rl "vendor:raylib"

PIXEL_WINDOW_HEIGHT :: 180


Game_Memory :: struct {
	player_pos:     rl.Vector2,
	player_texture: rl.Texture,
	some_number:    int,
	run:            bool,
}

g: ^Game_Memory

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {zoom = h / PIXEL_WINDOW_HEIGHT, target = {0, 0}, offset = {w / 2, h / 2}}
}

ui_camera :: proc() -> rl.Camera2D {
	return {zoom = f32(rl.GetScreenHeight()) / PIXEL_WINDOW_HEIGHT}
}

update :: proc() {
	input: rl.Vector2

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
	g.player_pos += input * rl.GetFrameTime() * 100
	g.some_number += 1

	if rl.IsKeyPressed(.ESCAPE) {
		g.run = false

	}
}

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.BeginMode2D(game_camera())
	rl.DrawTextureEx(g.player_texture, {0, 0}, 0, 1, rl.WHITE)
	rl.DrawRectangleV(g.player_pos, {10, 10}, rl.WHITE)
	rl.EndMode2D()

	rl.BeginMode2D(ui_camera())

	// NOTE: `fmt.ctprintf` uses the temp allocator. The temp allocator is
	// cleared at the end of the frame by the main application, meaning inside
	// `main_hot_reload.odin`, `main_release.odin` or `main_web_entry.odin`.
	rl.DrawText(
		fmt.ctprintf("some_number: %v\nplayer_pos: %v", g.some_number, g.player_pos),
		5,
		5,
		8,
		rl.WHITE,
	)

	rl.EndMode2D()

	rl.EndDrawing()
}

// @(export)
// game_update :: proc() {
// 	update()


// 	// Everything on tracking allocator is valid until end-of-frame.
// 	free_all(context.temp_allocator)
// }

// @(export)
// game_init_window :: proc() {
// 	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
// 	rl.InitWindow(1280, 720, "Odin + Raylib + Hot Reload template!")
// 	rl.SetWindowPosition(200, 200)
// 	rl.SetTargetFPS(500)
// 	rl.SetExitKey(nil)
// }

// @(export)
// game_init :: proc() {

// }

@(export)
game_should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			return false
		}
	}

	return g.run
}

@(export)
game_shutdown :: proc() {
	free(g)
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseWindow()
}

// @(export)
// game_memory :: proc() -> rawptr {
// 	return g
// }

// @(export)
// game_memory_size :: proc() -> int {
// 	return size_of(Game_Memory)
// }

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
game_parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(i32(w), i32(h))
}
