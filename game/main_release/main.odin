package main_release

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"

import ecs "../../my_ecs"

main :: proc() {
	world := ecs.create_world()
	context.logger = log.create_console_logger()
	log.error(world)
}