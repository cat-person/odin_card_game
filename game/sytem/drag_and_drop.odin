package system

// Used to mark object as draggable
Draggable :: struct {
    // define trajectory ???
}

// 
DropArea :: struct {
    //
}

// 
Dragged :: struct {
    delta: rl.Vector3
}

Dropped :: struct {
    delta: rl.Vector3
    velocity: rl.Vector3
    target: rl.Vector3
}

drag :: proc(ctx: esc.Context) {


}