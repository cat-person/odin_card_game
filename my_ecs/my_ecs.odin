package my_ecs

import "core:reflect"
import "core:fmt"

Entity :: struct {
    meow: string
}

World :: struct {
    entity_list: #soa[dynamic]Entity,
    systems: [dynamic]proc(value: int)
}


create_world :: proc(/*mem allocator*/) -> World {
    fmt.println("VVVVVVVVVVVVVVVVVV")
    return World {

    }
}

delete_me_call_all :: proc(world: ^World, value: int) {
    for system in world.systems {
        system(value)
    }
}

add_system :: proc(world: ^World, system: proc(value: int)) {
    append(&world.systems, system)
}