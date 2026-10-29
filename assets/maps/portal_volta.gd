extends Area2D

const CENA_EXTERNA = "res://scenes/map/coliseum.tscn"

var player_dentro: bool = false


func _ready() -> void:
	if GameState.batalha_vencida:
		visible = true
		monitoring = true
	else:
		visible = false
		monitoring = false


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	if not GameState.batalha_vencida:
		return

	if player_dentro:
		return

	player_dentro = true

	print("SAINDO DO COLISEU!")

	# Ativa o aparecimento no ponto definido no mapa externo.
	GameState.retornar_portal_externo = true

	# Troca de cena depois do processamento da física.
	get_tree().call_deferred(
		"change_scene_to_file",
		CENA_EXTERNA
	)


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_dentro = false
