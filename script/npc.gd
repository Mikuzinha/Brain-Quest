extends CharacterBody2D

@onready var interaction_label = $InteractionArea/InteractionLabel

var player_near = false


func _ready():
	interaction_label.visible = false


func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		player_near = true
		interaction_label.visible = true


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		player_near = false
		interaction_label.visible = false


func _input(event):
	if player_near and event.is_action_pressed("interact"):
		iniciar_dialogo()


func iniciar_dialogo():
	interaction_label.visible = false
	get_tree().call_group("dialogue", "iniciar_dialogo")
