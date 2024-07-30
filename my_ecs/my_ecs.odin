package my_ecs

import "core:reflect"

import "core:fmt"

Entity :: struct {
    id: u16,
    component_types: []typeid,
}

data: WorldData

Error :: string

WorldData :: struct {
    
}

World :: struct {
    entity_list: [100]Entity,
    system_list: [100]System,
    component_map: map[typeid][100]any,

    delete_me_entity_idx: u16,
    delete_me_system_idx: u16,

    add_entity: proc(self: ^World, component: ..any) -> Entity,
    remove_entity: proc(self: ^World),

    add_system: proc(self: ^World, system: proc(params: ..any)),

    init : proc(self: ^World),
    update : proc(self: ^World),
    destroy : proc(self: ^World),
}

System :: struct {
    tipeid_list: []typeid,
    system_itself: proc(parameters: ..any) 
}   

new_world :: proc() -> World {
    return World {
        entity_list = [100]Entity {},
        system_list = [100]System {},

        delete_me_system_idx = 0,
        
        add_entity = world_add_entity,
        remove_entity = world_remove_entity,

        add_system = world_add_system,
        // Remove system

        init = world_init,
        update = world_update,
        destroy = world_destroy
    }
}

world_add_entity :: proc(self: ^World, component: ..any) -> Entity {
    self.delete_me_entity_idx += 1
    new_entity := Entity {
        id = self.delete_me_entity_idx,    
    }
    self.entity_list[self.delete_me_entity_idx] = new_entity
    return new_entity
}

world_add_system :: proc(self: ^World, system: proc(params: ..any)) {
    self.delete_me_system_idx += 1

    // new_system := System {
    //     type_id_list = type_id_list,
    //     system_itself = system
    // }

    fmt.println("AAAAAA")
    fmt.println(typeid_of(type_of (system)))
    // self.system_list[self.delete_me_system_idx] = system
}

world_remove_entity :: proc(self: ^World) {
    // X_X
}

world_init :: proc(self: ^World) {
    
}

world_destroy :: proc(self: ^World) {
    free(&data)
}

// system_list: []System
// component_table := [100]

world_update :: proc(self: ^World) {
    // for(system in system_list) {
        // find entity with right list of components
        // go through lists with components
        // call system with appropriate params   
    // }
}