package my_ecs

import "core:fmt"

World :: struct {
    entity_list: [dynamic]string,
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

add_entity :: proc (world: ^World, components: ..any) -> string {
    entity_id := calc_id_1()
    append(&world.entity_list, entity_id)
    return entity_id
}

Entity :: struct {
    id: string,
    components: []any
}

calc_id_1 :: proc(components: ..any) -> string {
    return "1"
}

create_entity :: proc(components: ..any) -> Entity {
    return Entity {
        id = calc_id_1(components),
        components = components
    }
}


