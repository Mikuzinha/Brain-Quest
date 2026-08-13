extends CharacterBody2D

@export var speed := 200.0

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	if direction.length() > 0:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()
