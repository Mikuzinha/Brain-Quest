extends CharacterBody2D

@export_enum("guia", "lutador") var tipo_npc: String = "guia"

@onready var interaction_label = $InteractionArea/InteractionLabel

var player_near = false

func _ready() -> void:
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
	if player_near and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		interaction_label.visible = false

		get_parent().get_parent().get_node(
			"dialogue"
		).iniciar_dialogo_npc(tipo_npc)
