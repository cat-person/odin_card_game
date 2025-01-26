package main_release

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"

import ecs "../../my_ecs"

main :: proc() {
	world := ecs.create_world()

	context.logger = log.create_console_logger()

	ecs.add_entity(&world, {ecs.Name("Lucky"), ecs.PawCount(4), ecs.Sound("Meow")})
	ecs.add_entity(&world, {ecs.Name("Nemo")})

	ecs.add_system(&world, ecs.Name, hello_username)
//	ecs.add_system(&world, rawptr(put_on_shoes), PawCount)
//	ecs.add_system(&world, rawptr(do_a_sound), Name, Sound)

	hello_username(ecs.Name("from main John"))

	ecs.update_world(&world)

//	log.error(world)
}

put_on_shoes :: proc(value: ecs.PawCount) {
	for paw_idx in 0..<value {
		log.error("Put on shoes on paw", value)
	}
}

hello_username :: proc(name: ecs.Name) {
	log.error("Hello", name)
}

do_a_sound :: proc(name: ecs.Name, sound: ecs.Sound) {
	log.error(fmt.aprintfln("%s says %s", name, sound))
}