package source

Block :: struct {
	type: BlockType,
}

BlockType :: enum {
	BLOCK_AIR,
	BLOCK_GRASS,
	BLOCK_DIRT,
	BLOCK_STONE,
	BLOCK_WOOD,
	BLOCK_LEAVES,
	BLOCK_COUNT,
}