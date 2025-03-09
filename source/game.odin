package source

import "core:c"
import "core:math"
import rl "vendor:raylib"

run: bool

MAP_SIZE :: 16
BLOCK_SIZE :: 1.0

camera: rl.Camera3D
blocks: [MAP_SIZE][MAP_SIZE]Block

init :: proc() {
	run = true

	for x := 0; x < MAP_SIZE; x += 1 {
		for z := 0; z < MAP_SIZE; z += 1 {
			if ((x + z) % 2 == 0) {
				blocks[x][z].type = BlockType.BLOCK_GRASS
			} else {
				blocks[x][z].type = BlockType.BLOCK_DIRT
			}
		}
	}

	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(800, 600, "Minecraft")
	rl.SetTargetFPS(60)
	camera = rl.Camera3D {
		position   = {MAP_SIZE / 2.0, 10.0, MAP_SIZE / 2.0 + 5.0},
		target     = {MAP_SIZE / 2.0, 0.0, MAP_SIZE / 2.0},
		up         = {0.0, 1.0, 0.0},
		fovy       = 60.0,
		projection = rl.CameraProjection.PERSPECTIVE,
	}
}

update :: proc() {
	updateGame()
	drawGame()
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}


// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}


drawGame :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.SKYBLUE)

	rl.BeginMode3D(camera)
	{
		for x := 0; x < MAP_SIZE; x += 1 {
			for z := 0; z < MAP_SIZE; z += 1 {
				position := rl.Vector3{f32(x) * BLOCK_SIZE, 0.0, f32(z) * BLOCK_SIZE}
				color := GetBlockColor(blocks[x][z].type)
				rl.DrawCube(position, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, color)
				rl.DrawCubeWires(position, BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, rl.BLACK)
			}
		}

		// Draw coordinate axes for reference
		rl.DrawLine3D(rl.Vector3{0, 0.01, 0}, rl.Vector3{5, 0.01, 0}, rl.RED) // X-axis
		rl.DrawLine3D(rl.Vector3{0, 0.01, 0}, rl.Vector3{0, 5, 0}, rl.GREEN) // Y-axis
		rl.DrawLine3D(rl.Vector3{0, 0.01, 0}, rl.Vector3{0, 0.01, 5}, rl.BLUE) // Z-axis

		// Draw grid for reference
		rl.DrawGrid(20, 1.0)
	}
	rl.EndMode3D()

	// Draw UI
	rl.DrawFPS(10, 10)
	rl.DrawText("Use arrow keys to move camera", 10, 40, 20, rl.WHITE)
	rl.DrawText("PAGE UP/DOWN to change height", 10, 70, 20, rl.WHITE)
	rl.DrawText("Press R to rotate camera", 10, 100, 20, rl.WHITE)

	rl.EndDrawing()
}


updateGame :: proc() {
	if (rl.IsKeyDown(rl.KeyboardKey.RIGHT)) {camera.position.x += 0.2}
	if (rl.IsKeyDown(rl.KeyboardKey.LEFT)) {camera.position.x -= 0.2}
	if (rl.IsKeyDown(rl.KeyboardKey.DOWN)) {camera.position.z += 0.2}
	if (rl.IsKeyDown(rl.KeyboardKey.UP)) {camera.position.z -= 0.2}
	if (rl.IsKeyDown(rl.KeyboardKey.PAGE_UP)) {camera.position.y += 0.2}
	if (rl.IsKeyDown(rl.KeyboardKey.PAGE_DOWN)) {camera.position.y -= 0.2}

	// Update camera target to always look at the center of the map
	camera.target = {MAP_SIZE / 2.0, 0.0, MAP_SIZE / 2.0}

	// Optional: rotate camera around the center
	if (rl.IsKeyDown(rl.KeyboardKey.R)) {
		direction := camera.position - camera.target
		radius := rl.Vector3Length(direction)
		angle := math.atan2(direction.z, direction.x)

		// Rotate camera position
		angle += 0.01
		camera.position.x = camera.target.x + radius * math.cos(angle)
		camera.position.z = camera.target.z + radius * math.sin(angle)
	}
}


GetBlockColor :: proc(type: BlockType) -> rl.Color {
	#partial switch type {
	case .BLOCK_GRASS:
		return rl.Color{86, 176, 0, 255}
	case .BLOCK_DIRT:
		return rl.Color{150, 75, 0, 255}
	case .BLOCK_STONE:
		return rl.Color{128, 128, 128, 255}
	case:
		return rl.WHITE
	}
}
