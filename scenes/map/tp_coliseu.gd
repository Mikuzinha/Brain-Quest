extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("PLAYER ENTROU NO TP!")
		get_tree().call_deferred(
			"change_scene_to_file",
			"res://assets/maps/coliseum_interior.tscn"
		)
