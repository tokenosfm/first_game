extends CharacterBody2D

@export var speed = 250.0
var target_position: Vector2
var is_selected: bool = false : set = _set_selected

@onready var sprite = $AnimatedSprite2D
#WIZUALNE PODŚWIETLENIE
func _set_selected(value: bool):
	is_selected = value
	modulate = Color.GREEN if is_selected else Color.WHITE
func _ready():
	target_position = global_position
	var gm = get_tree().current_scene.find_child("GridManager")
	if gm:
		var grid_pos = gm.world_to_grid(global_position)
		gm.claim_cell(grid_pos, self)

func _physics_process(_delta):
	if global_position.distance_to(target_position) > 2:
		var direction = global_position.direction_to(target_position)
		velocity = direction * speed
		sprite.play("move")
		sprite.flip_h = direction.x < 0
		move_and_slide()
	else:
		global_position = target_position
		velocity = Vector2.ZERO
		sprite.play("idle")
