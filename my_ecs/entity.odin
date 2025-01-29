package my_ecs

EntityId :: distinct u16

Entity :: struct {
    id: EntityId,
    components: []any
}

calc_entity_id :: proc(world: ^World) -> EntityId {
    return EntityId(len(world.entities))
}