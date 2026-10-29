
extends CharacterBody2D

@onready var interaction_label = $InteractionArea/InteractionLabel
@onready var sprite = $AnimatedSprite2D

var player_near = false


func _ready():
	interaction_label.visible = false
	sprite.play("idle")


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
		get_viewport().set_input_as_handled()
		iniciar_dialogo()


func iniciar_dialogo():
	interaction_label.visible = false

	var dialogue = get_tree().current_scene.find_child("dialogue", true, false)

	if dialogue:
		dialogue.iniciar_dialogo_npc("gladiador")
	else:
		print("ERRO: dialogue não encontrado!")
