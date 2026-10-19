extends CharacterBody2D

const SPEED = 150.0

var can_move = true
var ultima_direcao = "right"

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:

	if not can_move:
		velocity = Vector2.ZERO
		animated_sprite.stop()
		animated_sprite.frame = 0
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

		# Só muda a direção quando anda para os lados
		if direction.x > 0:
			ultima_direcao = "right"

		elif direction.x < 0:
			ultima_direcao = "left"

		# Usa a animação baseada na última direção
		if ultima_direcao == "right":
			animated_sprite.play("walk_right")

		elif ultima_direcao == "left":
			animated_sprite.play("walk_left")

	else:
		velocity = Vector2.ZERO
		animated_sprite.stop()
		animated_sprite.frame = 0

	move_and_slide()


func _on_tp_coliseu_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
