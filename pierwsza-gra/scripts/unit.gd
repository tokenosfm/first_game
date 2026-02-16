extends CharacterBody2D

@export var speed = 250.0
var target_position: Vector2
var is_selected: bool = false : set = _set_selected
var current_path: Array[Vector2i] = []

@onready var sprite = $AnimatedSprite2D
@onready var GM = get_tree().current_scene.find_child("GridManager")

func _set_selected(value: bool):
	is_selected = value
	modulate = Color.GREEN if is_selected else Color.WHITE

func _ready():
	target_position = global_position
	sprite.play("idle")
	if GM:
		var grid_pos = GM.world_to_grid(global_position)
		GM.claim_cell(grid_pos, self)

func move_to_target(target_grid_pos: Vector2i):
	var start_grid_pos = GM.world_to_grid(global_position)
	current_path = GM.get_astar_path(start_grid_pos, target_grid_pos)

func _physics_process(_delta):
	if current_path.is_empty():
		velocity = Vector2.ZERO
		sprite.play("idle")
		return

	var next_grid_pos = current_path[0]
	var next_world_pos = GM.grid_to_world(next_grid_pos)
	
	if global_position.distance_to(next_world_pos) > 4:
		var direction = global_position.direction_to(next_world_pos)
		velocity = direction * speed
		sprite.play("move")
		if direction.x != 0:
			sprite.flip_h = direction.x < 0
		move_and_slide()
	else:
		current_path.remove_at(0)
