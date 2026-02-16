extends AnimatedSprite2D

@export_enum("bush_1", "bush_2", "bush_3", "bush_4") var wariant: String = "bush_1"

func _ready():
	play(wariant)
	
	frame = randi() % sprite_frames.get_frame_count(wariant)

	flip_h = [true, false].pick_random()
	
	var random_scale = randf_range(0.9, 1.1)
	scale = Vector2(random_scale, random_scale)
