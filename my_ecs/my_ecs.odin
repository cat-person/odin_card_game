package my_ecs

import "core:reflect"
import "core:fmt"

Entity :: struct {
    meow: string
}

World :: struct {
    entity_list: #soa[dynamic]Entity,
}

create_world :: proc(/*mem allocator*/) -> World {
    fmt.println("VVVVVVVVVVVVVVVVVV")
    return World {

    }
}

//stringify_world()