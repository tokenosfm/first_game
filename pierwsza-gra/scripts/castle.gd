extends StaticBody2D

@export var building_shape: Array[Vector2i] = [ 
	Vector2i(-2, 1), Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)
]
@export var building_name: String = "Zamek"
var is_selected: bool = false : set = _set_selected

func _ready():
	var gm = get_tree().current_scene.find_child("GridManager")
	if gm:
		var my_grid_pos = gm.world_to_grid(global_position)
		var cells = get_occupied_cells(my_grid_pos)
		gm.claim_multiple_cells(cells, self)

func _set_selected(value: bool):
	is_selected = value
	modulate = Color(1.5, 1.5, 1.5) if is_selected else Color.WHITE

func get_occupied_cells(start_grid_pos: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for offset in building_shape:
		cells.append(start_grid_pos + offset)
	return cells
