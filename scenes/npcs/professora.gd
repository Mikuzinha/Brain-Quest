extends CharacterBody2D

var player_perto: bool = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_perto = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_perto = false

func _input(event: InputEvent) -> void:
	if not player_perto:
		return

	if event.is_action_pressed("interact") and not event.is_echo():
		get_viewport().set_input_as_handled()

		var dialogue = get_tree().current_scene.find_child("dialogue", true, false)

		if dialogue != null:
			dialogue.iniciar_dialogo()
		else:
			print("ERRO: não encontrei o nó dialogue!")
