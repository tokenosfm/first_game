extends Node2D

@export var knight_scene: PackedScene
@export var archer_scene: PackedScene
@export var castle_scene: PackedScene
@export var units_container: Node2D
@export var ghost_preview: Sprite2D
@export var GridManager: Node2D

var unit_to_spawn: PackedScene = null

func _unhandled_input(event: InputEvent) -> void:
	if unit_to_spawn == null:
		return
	# 1. ANULOWANIE 
	if event.is_action_pressed("click_left"):
		unit_to_spawn = null
		get_viewport().set_input_as_handled()
		print("Anulowano stawianie jednostki.")
	elif event.is_action_pressed("cancel") or event.is_action_pressed("ui_cancel"):
		unit_to_spawn = null
		print("Anulowano klawiszem.")
	# 3. POTWIERDZENIE
	elif event.is_action_pressed("spawn_key"):
		if units_container != null:
			spawn_unit(get_global_mouse_position())

func spawn_unit(pos: Vector2) -> void:
	var grid_pos = GridManager.world_to_grid(pos)
	var new_object = unit_to_spawn.instantiate()
	var cells_to_occupy: Array[Vector2i] = [grid_pos]
	
	if new_object.has_method("get_occupied_cells"):
		cells_to_occupy = new_object.get_occupied_cells(grid_pos)

	if GridManager.are_all_cells_vacant(cells_to_occupy):
		units_container.add_child(new_object)
		
		var snapped_pos = GridManager.grid_to_world(grid_pos)
		new_object.global_position = snapped_pos
		
		if "target_position" in new_object:
			new_object.target_position = snapped_pos
			
		GridManager.claim_multiple_cells(cells_to_occupy, new_object)
	else:
		print("Miejsce zajęte!")
		new_object.queue_free()

func spawn_near_selected_building(building):
	var b_grid_pos = GridManager.world_to_grid(building.global_position)
	var spawn_pos = GridManager.find_empty_neighbor_cell(b_grid_pos)
	if spawn_pos != Vector2i(-1, -1):
		spawn_unit(GridManager.grid_to_world(spawn_pos))

func _on_spawn_warrior_pressed() -> void:
	unit_to_spawn = knight_scene
	print("Wybrano Rycerza do spawnu. Kliknij 'B' na mapie.")
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()

func _on_spawn_archer_pressed() -> void:
	unit_to_spawn = archer_scene
	print("Wybrano Łucznika do spawnu. Kliknij 'B' na mapie.")
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()

func _on_spawn_castle_pressed() -> void:
	unit_to_spawn = castle_scene
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()

func _process(_delta: float) -> void:
	if ghost_preview == null: return
	if unit_to_spawn != null:
		ghost_preview.visible = true
		ghost_preview.global_position = get_global_mouse_position()
		if ghost_preview.texture == null:
			prepare_ghost_texture()
	else:
		ghost_preview.visible = false
		ghost_preview.texture = null
	if GridManager != null and has_node("GridHighlight"):
		var mouse_grid_pos = GridManager.world_to_grid(get_global_mouse_position())
		var highlight_pos = GridManager.grid_to_world(mouse_grid_pos)
		var highlight_node = $GridHighlight
		highlight_node.global_position = highlight_pos
		highlight_node.visible = true

func prepare_ghost_texture():
	var temp_instance = unit_to_spawn.instantiate()
	var anim_sprite = temp_instance.get_node_or_null("AnimatedSprite2D")
	if anim_sprite:
		ghost_preview.texture = anim_sprite.sprite_frames.get_frame_texture("idle", 0)
	temp_instance.queue_free()
