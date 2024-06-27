package entity
import rl "vendor:raylib"

prevState: World

World :: struct {	
	cards: [dynamic]Card,
	deck: Deck
}
