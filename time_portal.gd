extends Area2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("Quem entrou: ", body.name)

	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/map/coliseum.tscn")
