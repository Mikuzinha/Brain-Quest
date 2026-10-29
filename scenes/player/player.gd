
extends CharacterBody2D

const SPEED = 150.0

var can_move = true
var ultima_direcao = "right"

@onready var animated_sprite = $AnimatedSprite2D


func _ready() -> void:
	# 1. Retorno da batalha para o interior do Coliseu.
	if GameState.retornar_posicao:
		global_position = GameState.posicao_retorno
		GameState.retornar_posicao = false
		print("PLAYER RETORNOU DA BATALHA!")

	# 2. Retorno do interior para o mapa externo.
	elif GameState.retornar_portal_externo:
		var spawn_externo = get_tree().current_scene.find_child(
			"SpawnSaidaColiseu", true, false
		)

		if spawn_externo != null:
			global_position = spawn_externo.global_position
			GameState.retornar_portal_externo = false
			print("PLAYER APARECEU NA SAÍDA DO COLISEU!")
		else:
			print("ERRO: SpawnSaidaColiseu NÃO ENCONTRADO!")

	# 3. Retorno de Roma para a sala de aula.
	
	elif GameState.voltou_de_roma:
		GameState.voltou_de_roma = false
		voltar_para_marker()


func voltar_para_marker() -> void:
	await get_tree().process_frame

	var spawn_volta = get_tree().current_scene.find_child(
		"SpawnVoltaSala", true, false
	)

	if spawn_volta != null:
		global_position = spawn_volta.global_position
		print("MARKER ENCONTRADO: ", spawn_volta.global_position)
		print("PLAYER POSICIONADO: ", global_position)
	else:
		print("ERRO: SpawnVoltaSala NÃO ENCONTRADO!")



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

		# Atualiza a direção quando anda para os lados.
		if direction.x > 0:
			ultima_direcao = "right"
		elif direction.x < 0:
			ultima_direcao = "left"

		# Animação conforme a última direção horizontal.
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
	pass
