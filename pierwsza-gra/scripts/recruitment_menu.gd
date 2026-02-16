extends CanvasLayer

@onready var unit_spawner = get_tree().current_scene.find_child("UnitSpawner")
@onready var global_manager = get_tree().current_scene.find_child("GlobalManager")

func _ready():
	hide()
	var gm = get_tree().current_scene.find_child("GlobalManager")
	gm.object_selected.connect(_on_object_selected)
	gm.selection_cleared.connect(hide)

func _on_object_selected(obj):
	if obj.has_method("get_occupied_cells"):
		if obj.building_name == "Zamek":
			show()
		else:
			hide()
	else:
		hide()

func _on_warrior_pressed() -> void:
	if global_manager and global_manager.selected_object:
		unit_spawner.unit_to_spawn = unit_spawner.knight_scene
		unit_spawner.spawn_near_selected_building(global_manager.selected_object)
		unit_spawner.unit_to_spawn = null

func _on_archer_pressed() -> void:
	if global_manager and global_manager.selected_object:
		unit_spawner.unit_to_spawn = unit_spawner.archer_scene
		unit_spawner.spawn_near_selected_building(global_manager.selected_object)
		unit_spawner.unit_to_spawn = null
