extends Area2D

var portal_ativo: bool = false

func _ready() -> void:
	visible = false
	monitoring = false
	body_entered.connect(_on_body_entered)

func ativar_portal() -> void:
	portal_ativo = true
	visible = true
	monitoring = true
	print("Portal ativado!")

func _on_body_entered(body: Node2D) -> void:
	if not portal_ativo:
		return

	if body.name == "Player":
		get_tree().change_scene_to_file(
			"res://scenes/map/coliseum.tscn"
		)
