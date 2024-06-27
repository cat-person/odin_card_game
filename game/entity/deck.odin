package entity
import rl "vendor:raylib"

Deck :: struct {	
    position: rl.Vector3,
	cards: [dynamic]Card
}

createDeck :: proc(cardModel: rl.Model) -> Deck {
    return Deck {
        position={0, 0, 0},
        cards = {
            Card {
                text="AAA",
                color=rl.RED,
                position={0, 0, 0},
                model=cardModel
            },
            Card {
                text="AAA",
                color=rl.YELLOW,
                position={0, 0, 0},
                model=cardModel
            },
            Card {
                text="AAA",
                color=rl.BLACK,
                position={0, 0, 0},
                model=cardModel
            },
            Card {
                text="AAA",
                color=rl.WHITE,
                position={0, 0, 0},
                model=cardModel
            },
            Card {
                text="AAA",
                color=rl.BROWN,
                position={0, 0, 0},
                model=cardModel
            },
            Card {
                text="AAA",
                color=rl.YELLOW,
                position={0, 0, 0},
                model=cardModel
            },
            Card {
                text="AAA",
                color=rl.YELLOW,
                position={0, 0, 0},
                model=cardModel
            }
        }
    }
}

// drawCard :: proc(deck: Deck) -> ([]Card, Card) {
// 	return deck.cards[1:], deck.cards[0] 
// }

getCardsToDraw :: proc(deck: Deck) -> []Card {
    return deck.cards[0:5]
}




