package my_ecs

import "core:reflect"

Entity :: struct {
    id: u16,
    name: string,
    // component_types: []typeid,
}

data: WorldData

WorldData :: struct {
    
}

World :: struct {
    entity_list: [100]Entity,
    system_list: [100]System,

    delete_me_system_idx: u16,

    add_entity: proc(self: ^World, name: string) -> Entity,
    remove_entity: proc(self: ^World),

    init : proc(self: ^World),
    update : proc(self: ^World),
    destroy : proc(self: ^World),
}

System :: struct {

}   

new_world :: proc() -> World{
    return World {
        entity_list = [100]Entity {},
        system_list = [100]System {},

        delete_me_system_idx = 0,
        
        add_entity = world_add_entity,
        remove_entity = world_remove_entity,

        init = world_init,
        update = world_update,
        destroy = world_destroy
    }
}

world_add_entity :: proc(self: ^World, name: string) -> Entity {
    self.delete_me_system_idx += 1
    new_entity := Entity {
        id = self.delete_me_system_idx,
        name = name    
    }
    self.entity_list[self.delete_me_system_idx] = new_entity
    return new_entity
}

world_remove_entity :: proc(self: ^World) {
    
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

// add_system :: proc(system: proc(components ...any)) {
//     fmt.println("added_system")
//     last_idx += 1
//     system_list[last_idx] = system
    
//     // Assuming that the system list is always sorted it can be done via binary search

//     for(idx = last_idx) {

//     }
// }

// remove_system :: proc(system: proc) {
//     fmt.println("remove_system")
//     last_idx -= 1
// }

// component :: struct($DataType: typeid) {
//     entity: Entity,
//     data: DataType 
// }