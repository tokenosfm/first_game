extends Node2D

signal object_selected(object)
signal selection_cleared

var selected_object = null
@export var grid_manager: Node2D

func _unhandled_input(event):
# 1. ZAZNACZANIE
	if event.is_action_pressed("click_left"):
		var clicked = get_object_under_mouse()
		
		if selected_object:
			selected_object.is_selected = false
			
		selected_object = clicked
			
		if selected_object:
			selected_object.is_selected = true
			object_selected.emit(selected_object)
		else:
			selection_cleared.emit()
# 2. WYDAWANIE ROZKAZU
	if event.is_action_pressed("click_right") and selected_object:
		if selected_object is CharacterBody2D:
			var mouse_pos = get_global_mouse_position()
			var target_grid_pos = grid_manager.world_to_grid(mouse_pos)
			
			if grid_manager.is_cell_vacant(target_grid_pos):
				var current_grid_pos = grid_manager.world_to_grid(selected_object.global_position)
				
				# Logika zamiany pól:
				grid_manager.release_cell(current_grid_pos)
				grid_manager.claim_cell(target_grid_pos, selected_object)
				selected_object.target_position = grid_manager.grid_to_world(target_grid_pos)
			else:
				print("To pole jest już zajęte!")

func get_object_under_mouse():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	var result = space_state.intersect_point(query)
		
	if result:
		var collider = result[0].collider
		if "is_selected" in collider:
			return collider
	return null
