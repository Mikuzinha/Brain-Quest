extends Area2D

var portal_ativo = false


func _ready():
	visible = false
	monitoring = false


func ativar_portal():
	portal_ativo = true
	visible = true
	monitoring = true


func _on_body_entered(body):
	if portal_ativo and body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/map/coliseum.tscn")
