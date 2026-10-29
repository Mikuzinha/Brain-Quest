
extends Area2D

const CENA_SALA = "res://scenes/map/classroom.tscn"

var portal_ativo: bool = false
var player_pode_entrar: bool = false


func _ready() -> void:
	visible = false
	monitoring = false

	if GameState.batalha_vencida:
		ativar_portal()

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func ativar_portal() -> void:
	portal_ativo = true
	visible = true
	monitoring = true

	print("Portal de volta ativado!")


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	if not portal_ativo:
		return

	if not player_pode_entrar:
		print("Afaste-se do portal para liberá-lo.")
		return

	print("VOLTANDO PARA A SALA DE AULA!")

	# Não usar a posição do portal externo como posição de retorno.
	GameState.retornar_posicao = false
	GameState.retornar_portal_externo = false
	GameState.voltou_de_roma = true

	get_tree().call_deferred(
		"change_scene_to_file",
		CENA_SALA
	)


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if portal_ativo:
			player_pode_entrar = true
			print("PORTAL LIBERADO!")
