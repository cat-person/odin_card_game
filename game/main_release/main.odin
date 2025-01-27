package main_release

import "core:os"
import "core:mem"
import "core:fmt"
import "core:log"
import "core:bytes"
import "core:reflect"

main :: proc() {
	context.logger = log.create_console_logger()

	some_data := SomeComplexData {
		id = "1",
		number = 123
	}

	hello_username(some_data)

	hello_username_raw(transmute([size_of(SomeComplexData)]byte)some_data)

	buffer := bytes.Buffer{};

//	bytes.buffer_write(&buffer, transmute([]byte)BigNum(123))
}



BigNum :: distinct i128

SomeComplexData :: struct {
	id: string,
	number: int,
	data: []byte
}

System :: struct($T: typeid) {
hello_username_raw : proc(raw_data: [size_of(SomeComplexData)]byte) {
	data := transmute(SomeComplexData)raw_data
	hello_username(data)
}

hello_username :  proc(data: SomeComplexData) {
	log.error("Hello", data)
}
}

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