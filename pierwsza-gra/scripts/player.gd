extends CharacterBody2D

const SPEED = 300.0
@onready var sprite = $AnimatedSprite2D 

func _physics_process(_delta: float) -> void:
	# 1. Sprawdzamy, czy aktualnie trwa animacja ataku. 
	# Jeśli tak, przerywamy wykonywanie reszty funkcji (blokujemy ruch i zmianę animacji).
	if sprite.animation == "attack" and sprite.is_playing():
		return

	# 2. Obsługa ataku
	if Input.is_action_just_pressed("ui_accept"):
		sprite.play("attack")
		velocity = Vector2.ZERO # Zatrzymujemy postać podczas ataku
		return # Kończymy funkcję w tej klatce, by nie przejść do ruchu

	# 3. Pobieranie kierunku (standardowy ruch)
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		sprite.play("move")
		
		if direction.x > 0:
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.flip_h = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		sprite.play("idle")

	move_and_slide()
