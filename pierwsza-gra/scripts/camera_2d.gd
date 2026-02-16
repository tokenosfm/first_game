extends Camera2D
@export var scroll_speed: float = 500.0
@export var edge_margin: float = 20.0

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size
	var move_vec = Vector2.ZERO

	# Sprawdzanie krawędzi
	if mouse_pos.x < edge_margin:
		move_vec.x = -1
	elif mouse_pos.x > screen_size.x - edge_margin:
		move_vec.x = 1
		
	if mouse_pos.y < edge_margin:
		move_vec.y = -1
	elif mouse_pos.y > screen_size.y - edge_margin:
		move_vec.y = 1

	global_position += move_vec.normalized() * scroll_speed * delta * zoom.x

	# Ograniczenie pozycji
	limit_camera()

func limit_camera():
	global_position.x = clamp(global_position.x, limit_left + (get_viewport_rect().size.x / 2 / zoom.x), limit_right - (get_viewport_rect().size.x / 2 / zoom.x))
	global_position.y = clamp(global_position.y, limit_top + (get_viewport_rect().size.y / 2 / zoom.y), limit_bottom - (get_viewport_rect().size.y / 2 / zoom.y))
