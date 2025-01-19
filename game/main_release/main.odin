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

	ecs.add_system(&world, hello_system)
	ecs.add_system(&world, bye_system)
	ecs.delete_me_call_all(&world, 2)
}

hello_system :: proc(value: int) {
	log.error("Hello", value)
}

bye_system :: proc(value: int) {
	log.error("Bye", value)
}