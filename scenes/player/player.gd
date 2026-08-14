extends CharacterBody2D

const SPEED = 300.0

var can_move = false


func _physics_process(_delta: float) -> void:

	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
