package main_release

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"
import "core:bytes"
import "core:reflect"

main :: proc() {
	context.logger = log.create_console_logger()
	hello_username(transmute([size_of(Name)]byte)Name("Johny"))
}

handle_query :: proc($T: typeid, raw_data: [size_of(T)]byte, logic: proc(T)) {
	logic(transmute(T)raw_data)
}

hello_username :: proc(raw_data: [size_of(Name)]byte) {
	handle_query(Name, raw_data, proc(name: Name) {
		log.error("Hello", name)
	})
}

Name :: distinct string

//	world := ecs.create_world()
//
//	context.logger = log.create_console_logger()
//
//	ecs.add_entity(&world, {ecs.Name("Lucky"), ecs.PawCount(4), ecs.Sound("Meow")})
//	ecs.add_entity(&world, {ecs.Name("Nemo")})
//
//	ecs.add_system(&world, ecs.Name, hello_username)
//	ecs.add_system(&world, ecs.PawCount, put_on_shoes)
//
//	hello_username(ecs.Name("from main John"))
//
//	ecs.update_world(&world)
//
//put_on_shoes :: proc(value: ecs.PawCount) {
//	for paw_idx in 0..<value {
//		log.error("Put on shoes on paw", paw_idx)
//	}
//}
//
//hello_username :: proc(name: ecs.Name) {
//	log.error("Hello", name)
//}
//
//do_a_sound :: proc(name: ecs.Name, sound: ecs.Sound) {
//	log.error(fmt.aprintfln("%s says %s", name, sound))
//}