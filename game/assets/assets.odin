package game

import "core:path/filepath"
import "core:strings"
import "core:os"
import rl "vendor:raylib"

Assets :: struct {
    models : map[string]rl.Model
    textures: map[string]rl.Texture2D
}

loadAssets :: proc() -> (result: Assets) {
    // Remove hrdcoded assests
    // folder := os.open("game/assets/models")
    // for(file in folder) {

    // }
}

delete :: proc() 