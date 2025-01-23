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

	ecs.add_entity(&world, 1, "aaaa")

	ecs.add_system(&world, cast(rawptr)hello_system, int)
	ecs.add_system(&world, cast(rawptr)bye_system, int)
	ecs.add_system(&world, cast(rawptr)hello_username, string)

	ecs.delete_me_call_all(&world)
	hello_username("meow")
}

hello_system :: proc(value: int) {
	log.error("Hello", value)
}

bye_system :: proc(value: int) {
	log.error("Bye", value)
}

hello_username :: proc(username: string) {
	log.error("Hello", username)
}