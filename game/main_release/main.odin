package main_release

import "core:os"
import "core:mem"
import "core:fmt"

import game ".."

UseTrackingAllocator :: #config(UseTrackingAllocator, false)

main :: proc() {
	fmt.println("AAAAAAAAA")
	game := game.new_game()

	game.create(&game) 

	for game.update(&game) {
		
	}

	game.destroy(&game)
}

// make game use good GPU on laptops etc
@(export)
NvOptimusEnablement: u32 = 1

@(export)
AmdPowerXpressRequestHighPerformance: i32 = 1