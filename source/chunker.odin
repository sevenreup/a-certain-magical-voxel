package source

import rl "vendor:raylib"

CHUNK_SIZE :: 16
CHUNK_HEIGHT :: 16
RENDER_DISTANCE :: 16

Chunk :: struct {
	blocks:   [CHUNK_SIZE][CHUNK_HEIGHT][CHUNK_SIZE]Block,
	position: rl.Vector3,
}

chunks: []Chunk

InitChunks :: proc() {
	index := 0
	for x := -RENDER_DISTANCE; x <= RENDER_DISTANCE; x += 1 {
		for z := -RENDER_DISTANCE; z <= RENDER_DISTANCE; z += 1 {
			GenerateChunk(&chunks[index], x, z)
			UpdateBlockVisibility(&chunks[index])
			index += 1
		}
	}
}

GenerateChunk :: proc(chunk: ^Chunk, chunkX: int, chunkY: int) {}

UpdateBlockVisibility :: proc(chunk: ^Chunk) {}

DrawChunks :: proc() {}
