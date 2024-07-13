// For making a release exe that does not use hot reload.
// Tried to simplify main_release

package main_release

// import "core:log"
import "core:os"
import "core:mem"
import "core:fmt"

import game ".."
import "../ecs"

UseTrackingAllocator :: #config(UseTrackingAllocator, false)

main :: proc() {
	// when ODIN_DEBUG {
    //     defer {
    //         if len(track.allocation_map) > 0 {
    //             fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
    //             for _, entry in track.allocation_map {
    //                 fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
    //             }
    //         }
    //         if len(track.bad_free_array) > 0 {
    //             fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
    //             for entry in track.bad_free_array {
    //                 fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
    //             }
    //         }
    //         mem.tracking_allocator_destroy(&track)
    //     }
    // }

	when UseTrackingAllocator {
		default_allocator := context.allocator
		// tracking_allocator: Tracking_Allocator
		// tracking_allocator_init(&tracking_allocator, default_allocator)
		// context.allocator = allocator_from_tracking_allocator(&tracking_allocator)
	}

	mode: int = 0
	when ODIN_OS == .Linux || ODIN_OS == .Darwin {
		mode = os.S_IRUSR | os.S_IWUSR | os.S_IRGRP | os.S_IROTH
	}

	// logh, logh_err := os.open("log.txt", (os.O_CREATE | os.O_TRUNC | os.O_RDWR), mode)

	// if logh_err == os.ERROR_NONE {
	// 	os.stdout = logh
	// 	os.stderr = logh
	// }

	// logger := logh_err == os.ERROR_NONE ? log.create_file_logger(logh) : log.create_console_logger()
	// context.logger = logger
	
	world := ecs.init_ecs()
	defer ecs.deinit_ecs(&world)

	game.init_window(&world)
	game.init(&world)

	for game.update(&world) {

		// when UseTrackingAllocator {
		// 	for b in tracking_allocator.bad_free_array {
		// 		log.error("Bad free at: %v", b.location)
		// 	}

		// 	clear(&tracking_allocator.bad_free_array)
		// }

		free_all(context.temp_allocator)
	}

	free_all(context.temp_allocator)
	game.shutdown_game(&world)
	game.shutdown_window(&world)
	
	// if logh_err == os.ERROR_NONE {
	// 	log.destroy_file_logger(logger)
	// }

	// when UseTrackingAllocator {
	// 	for key, value in tracking_allocator.allocation_map {
	// 		log.error("%v: Leaked %v bytes\n", value.location, value.size)
	// 	}

	// 	tracking_allocator_destroy(&tracking_allocator)
	// }
}

// make game use good GPU on laptops etc

@(export)
NvOptimusEnablement: u32 = 1

@(export)
AmdPowerXpressRequestHighPerformance: i32 = 1