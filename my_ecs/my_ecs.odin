package my_ecs

import "core:reflect"
import "core:fmt"

Entity :: struct {
    components: map[string]typeid
}

World :: struct {
    entity_list: #soa[dynamic]Entity,
    systems: map[typeid]rawptr
}

create_world :: proc(/*mem allocator*/entities: ..Entity) -> World {
    fmt.println("VVVVVVVVVVVVVVVVVV")
    return World {
//        entity_list = entities
    }
}

delete_me_call_all :: proc(world: ^World) {
    for system_type_id in world.systems {
        fmt.println("delete_me_call_all", system_type_id)
    }
}

add_system :: proc(world: ^World, system: rawptr, arg_types: typeid) {
    world.systems[arg_types] = system
}