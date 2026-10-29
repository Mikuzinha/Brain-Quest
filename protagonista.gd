extends Node2D

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animacao.play("idle")


func atacar() -> void:
	# Executa a animação de ataque
	animacao.play("attack")

	# Espera a animação terminar
	await animacao.animation_finished

	# Volta para a animação parado
	animacao.play("idle")


func voltar_idle() -> void:
	animacao.play("idle")
