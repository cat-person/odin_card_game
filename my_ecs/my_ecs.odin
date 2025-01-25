package my_ecs

import "core:fmt"

World :: struct {
    entities: map[EntityId]Entity,
    components: map[typeid][]Component,
    args_typeids_by_system: map[SystemId]typeid,
    systems: map[SystemId]proc(Component)

}

EntityId :: distinct u16
SystemId :: distinct u16

create_world :: proc(/*mem allocator*/) -> World {
    fmt.println("create world")
    world := World {}
//    world.components[typeid_of(Name)] = []{
//        cast(Component)Name("John"),
//        cast(Component)Name("Karen")
//    }
    return world
}

delete_me_call_all :: proc(world: ^World) {
    for system_type_id in world.systems {
        fmt.println("delete_me_call_all", system_type_id)
    }
}

add_system :: proc(world: ^World, $T: typeid, system: proc(args: T)) {
    system_id := calc_system_id(world)
    world.systems[system_id] = cast(proc(Component))system
    world.args_typeids_by_system[system_id] = T

    fmt.println(system)
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
        arg_type := world.args_typeids_by_system[system_id]
        system := world.systems[system_id]

        call_system(world, arg_type, system)
    }
}

//get_components :: proc(type: typeid) {
//    if(T == Name) {
//        return {
//            Name("John"),
//            Name("Karen")
//        }
//    }
//    return nil
//}


PawCount :: distinct int
Name :: distinct string
Sound :: distinct string

Component :: union {
    PawCount,
    Name,
    Sound,
}

//System :: struct {
//    argType: typeid,
//    system: proc(Component)
//}

call_system :: proc(world: ^World, arg_type: typeid, system: proc(Component)) {
    fmt.println("ecs.call_system", arg_type, system)
    fmt.println("ecs.get_components")
    components := []Name{
        Name("John"),
        Name("Karen")
    }
    
//    fmt.println("ecs.get_components", components)
    for component in components {
        fmt.println("ecs.get_components", component)
        (cast(proc(Name))system)(component)
    }
}