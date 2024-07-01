package game

import "core:math/linalg"
import "core:fmt"
import rl "vendor:raylib"

import "entity"
import "utils"
import "ecs"

PixelWindowHeight :: 180

g_mem: ^entity.World

card_coll_point: rl.Vector3

dragged_card : ^entity.Card


game_camera := rl.Camera3D {
	position = { 0.0, 0.4, -0.4 } ,
	target = { 0.0, 0.0, 0.0 },
	up = { 0.0, 1.0, 0.0 },
	fovy = 30
}

card_model: rl.Model

update :: proc() {
	input: rl.Vector3
	mouse_ray := rl.GetMouseRay(rl.GetMousePosition(), game_camera)

	// Extract
	if(dragged_card == nil){
		for &card in g_mem.cards {
			card_transform := rl.MatrixTranslate(card.position.x, card.position.y, card.position.z)
			coll := rl.GetRayCollisionMesh(mouse_ray, card.model.meshes[0], card_transform)
				if(coll != {}) {
					card.color = rl.LIME
					
					if(rl.IsMouseButtonDown(.LEFT)) {
						card.color = rl.GREEN
						dragged_card = &card
						card_coll_point = coll.point
					}
					break
				}
		}
	} 


	if(dragged_card != nil) {

		if(rl.IsMouseButtonDown(.LEFT)) {

			mouse_ray := rl.GetMouseRay(rl.GetMousePosition(), game_camera)
			card_transform := rl.MatrixTranslate(dragged_card.position.x, dragged_card.position.y, dragged_card.position.z)
			coll := rl.GetRayCollisionMesh(mouse_ray, dragged_card.model.meshes[0], card_transform)

			dragged_card.position += coll.point - card_coll_point
			
			card_coll_point = coll.point
		} else {
			dragged_card = nil
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
			for &card, idx in g_mem.deck.cards {
				card.position = g_mem.deck.position + {0, (f32)(5 - idx) * 0.002, 0} // <= should be card.height or something
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
	rl.SetTargetFPS(60)
}

@(export)
game_init :: proc() {
	card_model = rl.LoadModel("game/assets/models/card.obj")

	g_mem = new(entity.World)

	g_mem^ = entity.World {
		cards = {
			{
				text="AAA",
				color=rl.PINK,
				position={0.05, 0, 0},
				model=card_model
			}
		},
		deck = entity.createDeck(card_model) 
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