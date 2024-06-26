package entity
import rl "vendor:raylib"

Card :: struct {	
	text: string,
    color: rl.Color,
    position: rl.Vector3,
    model: rl.Model,
}

createCard :: proc(givenModel: rl.Model) -> Card {
    return Card {
        text="AAA",
        color=rl.YELLOW,
        position={0, 0, 0},
        model=givenModel
    }
}





