package my_ecs

EntityId :: distinct u16

Entity :: struct {
    id: EntityId,
    components: map[typeid][]byte
}

calc_entity_id :: proc(world: ^World) -> EntityId {
    return EntityId(len(world.entities))
}