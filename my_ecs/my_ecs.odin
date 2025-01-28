package my_ecs

import "core:fmt"
import "core:bytes"

Buffer :: bytes.Buffer

World :: struct {
    entities: map[EntityId]Entity,
    components: map[typeid]Query,

    args_typeids_by_system: map[SystemId]typeid,
    systems: map[SystemId]rawptr
}

EntityId :: distinct u16
SystemId :: distinct u16

create_world :: proc(/*mem allocator*/) -> World {
    fmt.println("create world")
    world := World {}
//    name_buffer := bytes.new_buffer()
//    name_buffer.write_string

//    world.components[Name] = Buffer
//        transmute([]byte)Name("John"),
//        transmute([]byte)Name("Karen")
//    }
//
//    paws_buffer := bytes.new_buffer()
//    paws_buffer := bytes.new_buffer()
//
//    world.components[PawCount] = [][]byte{
//        transmute([]byte)PawCount(2),
//        transmute([]byte)PawCount(4)
//    }
    return world
}

delete_me_call_all :: proc(world: ^World) {
    for system_type_id in world.systems {
        fmt.println("delete_me_call_all", system_type_id)
    }
}

add_system_1 :: proc(world: ^World, $T: typeid, system: proc(arg: T)) {
    system_id := calc_system_id(world)
    world.systems[system_id] = cast(rawptr)system
    world.args_typeids_by_system[system_id] = T

    fmt.println(system)
}

//add_system_2 :: proc(world: ^World, $T1: typeid, $T2: typeid, system: proc(arg1: T1, arg2: T2)) {
//    system_id := calc_system_id(world)
//    world.systems[system_id] = cast(rawptr)system
//    world.args_typeids_by_system[system_id] = []typeid{T1, T2}
//
//    fmt.println(system)
//}

add_system :: proc {
    add_system_1,
//    add_system_2
}

add_entity :: proc (world: ^World, components: []any) -> EntityId {
    entity_id := calc_id(world, components)
    world.entities[entity_id] = Entity {
        id = entity_id,
        components = components
    }
    return entity_id
}

Entity :: struct {
    id: EntityId,
    components: []any
}

calc_id :: proc(world: ^World, components: []any) -> EntityId {
    return EntityId(len(world.entities))
}

calc_system_id :: proc(world: ^World) -> SystemId {
    fmt.println("ecs::calc_system_id: ", len(world.systems))
    return SystemId(len(world.systems))
}

update_world ::proc(world: ^World) {
    for system_id in world.systems {
        call_system(world, world.args_typeids_by_system[system_id], world.systems[system_id])
    }
}

PawCount :: distinct int
Name :: distinct string
Sound :: distinct string

Component :: union {
    PawCount,
    Name,
    Sound,
}

//Archetype :: struct($T1, $T: typeid) {
//
//}

call_system :: proc(world: ^World, arg_type: typeid, system: rawptr) {
    fmt.println("ecs.call_system", arg_type, system)

    switch(arg_type) {
        case Name:
            fmt.println("ecs.call_system", arg_type, system)
            hardcoded_names := [?]Name{
                Name("John"),
                Name("Karen")
            }
            for name in hardcoded_names {
                (cast(proc(Name))system)(name)
            }
        case PawCount: {
            hardcoded_paw_counts := [?]PawCount{
                PawCount(2),
                PawCount(4)
            }
            for paw_count in hardcoded_paw_counts {
                (cast(proc(PawCount))system)(paw_count)
            }
        }
    }
}