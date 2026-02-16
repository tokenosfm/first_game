extends Node2D
var occupied_cells = {}

@export var all_layers = Array[TileMapLayer]
var astar_grid: AStarGrid2D

func _ready():
	setup_astar()

func world_to_grid(world_pos: Vector2) -> Vector2i:
	return all_layers[0].local_to_map(all_layers[0].to_local(world_pos))

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return all_layers[0].to_global(all_layers[0].map_to_local(grid_pos))

func is_cell_vacant(grid_pos: Vector2i) -> bool:
	return not occupied_cells.has(grid_pos)

func claim_cell(grid_pos: Vector2i, entity: Node):
	occupied_cells[grid_pos] = entity
	if astar_grid.is_in_boundsv(grid_pos):
		astar_grid.set_point_solid(grid_pos, true)

func release_cell(grid_pos: Vector2i):
	occupied_cells.erase(grid_pos)
	if astar_grid.is_in_boundsv(grid_pos):
		astar_grid.set_point_solid(grid_pos, false)

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

func setup_astar():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(-100, -100, 200, 200)
	astar_grid.cell_size = Vector2(64, 64)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar_grid.update()

	var all_cells = all_layers.get_used_cells()

	for cell in all_cells:
		var tile_data = all_layers.get_cell_tile_data(cell)
		if tile_data:
			var is_solid = tile_data.get_custom_data("is_solid")
			if is_solid:
				if astar_grid.is_in_boundsv(cell):
					astar_grid.set_point_solid(cell, true)
					
	print("AStar zainicjalizowany i teren wczytany.")
	
	for cell in all_cells:
		var tile_data = all_layers.get_cell_tile_data(cell)
		if not tile_data: continue
		var my_elevation = tile_data.get_custom_data("elevation")
		var neighbors = [Vector2i(1, 0), Vector2i(0, 1)]
		
		for neighbor_offset in neighbors:
			var neighbor_cell = cell + neighbor_offset
			var neighbor_data = all_layers.get_cell_tile_data(neighbor_cell)
			
			if neighbor_data:
				var neighbor_elevation = neighbor_data.get_custom_data("elevation")
				if my_elevation != neighbor_elevation:
					if astar_grid.is_in_boundsv(cell) and astar_grid.is_in_boundsv(neighbor_cell):
						astar_grid.disconnect_points(cell, neighbor_cell)
						astar_grid.disconnect_points(neighbor_cell, cell)

func get_astar_path(start_grid_pos: Vector2i, end_grid_pos: Vector2i) -> Array[Vector2i]:
	if not astar_grid.is_in_boundsv(start_grid_pos) or not astar_grid.is_in_boundsv(end_grid_pos):
		print("Błąd: Punkt poza granicami AStarGrid!")
		return []

	var path = astar_grid.get_id_path(start_grid_pos, end_grid_pos)
	if path.size() > 0:
		path.remove_at(0)
	return path
