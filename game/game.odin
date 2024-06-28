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

cardCollPoint: rl.Vector3

draggedCard : ^entity.Card


game_camera := rl.Camera3D {
	position = { 0.0, 0.4, -0.4 } ,
	target = { 0.0, 0.0, 0.0 },
	up = { 0.0, 1.0, 0.0 },
	fovy = 30
}

cardModel: rl.Model

update :: proc() {
	input: rl.Vector3
	mouse_ray := rl.GetMouseRay(rl.GetMousePosition(), game_camera)

	// Extract
	if(draggedCard == nil){
		for &card in g_mem.cards {
			cardTransform := rl.MatrixTranslate(card.position.x, card.position.y,card.position.z)
			coll := rl.GetRayCollisionMesh(mouse_ray, card.model.meshes[0], cardTransform)
				if(coll != {}) {
					card.color = rl.LIME
					
					if(rl.IsMouseButtonDown(.LEFT)) {
						card.color = rl.GREEN
						draggedCard = &card
						cardCollPoint = coll.point
					}
					break
				}
		}
	} 


	if(draggedCard != nil) {

		if(rl.IsMouseButtonDown(.LEFT)) {

			mouse_ray := rl.GetMouseRay(rl.GetMousePosition(), game_camera)
			cardTransform := rl.MatrixTranslate(draggedCard.position.x, draggedCard.position.y,draggedCard.position.z)
			coll := rl.GetRayCollisionMesh(mouse_ray, draggedCard.model.meshes[0], cardTransform)

			draggedCard.position += coll.point - cardCollPoint
			
			cardCollPoint = coll.point
		} else {
			draggedCard = nil
		}
	}

	// if(draggedCard != nil) {
	// 	if (rl.IsMouseButtonDown(.LEFT)){
	// 		if(mouse_point != {0, 0, 0}) {
	// 			deck, drawnCard := entity.drawCard(g_mem.deck)

	// 			g_mem.deck = deck
				
	// 			drawnCard.color = rl.GREEN
	// 			drawnCard.position += coll.point - mouse_point
	// 			draggedCard = &drawnCard

	// 			append(&g_mem.cards, drawnCard)
	// 		}
	// 		// mouse_point = coll.point
	// 	} else {
	// 		// drawnCard.color = rl.LIME
	// 		mouse_point = {0,0,0}
	// 		draggedCard = nil
	// 	}
	// }

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

// findCollision :: proc(world: World, mouse_ray: Ray) -> ^rl.RayCollision {
// 	return nil
// }

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
	cardModel = rl.LoadModel("game/assets/models/card.obj")

	g_mem = new(entity.World)

	g_mem^ = entity.World {
		cards = {
			{
				text="AAA",
				color=rl.PINK,
				position={0.05, 0, 0},
				model=cardModel
			}
		},
		deck = entity.createDeck(cardModel) 
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