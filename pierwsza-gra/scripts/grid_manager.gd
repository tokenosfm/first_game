extends Node2D
var occupied_cells = {}

@export var tile_map_layer: TileMapLayer

func world_to_grid(world_pos: Vector2) -> Vector2i:
	return tile_map_layer.local_to_map(tile_map_layer.to_local(world_pos))

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return tile_map_layer.to_global(tile_map_layer.map_to_local(grid_pos))

func is_cell_vacant(grid_pos: Vector2i) -> bool:
	return not occupied_cells.has(grid_pos)

func claim_cell(grid_pos: Vector2i, entity: Node):
	occupied_cells[grid_pos] = entity

func release_cell(grid_pos: Vector2i):
	occupied_cells.erase(grid_pos)

func are_all_cells_vacant(cells: Array[Vector2i]) -> bool:
	for cell in cells:
		if not is_cell_vacant(cell):
			return false
	return true

func claim_multiple_cells(cells: Array[Vector2i], entity: Node):
	for cell in cells:
		claim_cell(cell, entity)

func release_multiple_cells(cells: Array[Vector2i]):
	for cell in cells:
		release_cell(cell)

func find_empty_neighbor_cell(center_grid_pos: Vector2i) -> Vector2i:
	var potential_cells: Array[Vector2i] = []
	
	for x in range(-3, 3):
		for y in range(0, 3):
			var check_pos = center_grid_pos + Vector2i(x, y)
			if is_cell_vacant(check_pos):
				potential_cells.append(check_pos)
	
	if potential_cells.size() > 0:
		potential_cells.shuffle() 
		return potential_cells[0]
			
	return Vector2i(-1, -1)
