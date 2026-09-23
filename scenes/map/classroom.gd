extends Node2D

@onready var player = $Player
@onready var spawn_point = $SpawnPoint


func _ready():
	player.position = spawn_point.position
