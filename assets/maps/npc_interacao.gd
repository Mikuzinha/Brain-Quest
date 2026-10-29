
extends CharacterBody2D

@export_enum("guia", "lutador") var tipo_npc: String = "guia"

@onready var interaction_label = $InteractionArea/InteractionLabel
@onready var sprite = $AnimatedSprite2D

var player_near: bool = false


func _ready() -> void:
	sprite.play("idle")
	# Se o lutador já foi derrotado, ele desaparece.
	if tipo_npc == "lutador" and GameState.lutador_derrotado:
		queue_free()
		return

	interaction_label.visible = false


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_near = true
		interaction_label.visible = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_near = false
		interaction_label.visible = false


func _input(event: InputEvent) -> void:
	if player_near and event.is_action_pressed("interact") and not event.is_echo():
		get_viewport().set_input_as_handled()

		interaction_label.visible = false

		# Procura o diálogo na cena atual.
		var dialogue = get_tree().current_scene.find_child(
			"dialogue", true, false
		)

		if dialogue:
			dialogue.iniciar_dialogo_npc(tipo_npc)
		else:
			print("ERRO: não encontrei o nó dialogue!")
