extends CanvasLayer

@onready var panel = $Panel

func _ready():
	visible = false


func mostrar_notificacao():
	visible = true
	
	await get_tree().create_timer(3.0).timeout
	
	visible = false
