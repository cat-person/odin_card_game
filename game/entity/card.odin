package entity
import rl "vendor:raylib"
import "core:fmt"

Card :: struct {	
	text: string,
    color: rl.Color,
    position: rl.Vector3,
    model: rl.Model,
    print: proc(givenModel: rl.Model) -> (),
}

createCard :: proc(givenModel: rl.Model) -> Card {
    return {
        text="AAA",
        color=rl.YELLOW,
        position={0, 0, 0},
        model=givenModel,
        print=print_hello
    }
}

print_hello :: proc(givenModel: rl.Model) {
    fmt.print("Hello $###############################")
}




