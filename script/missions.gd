extends CanvasLayer

@onready var mission_list = $MissionList

var missions = [
	"🟡 O Mistério da História",

"Descubra em que ano aconteceu",
"determinado acontecimento histórico.",

"Status: EM ANDAMENTO"
]


func _ready():
	visible = false
	atualizar_missoes()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_J:
			visible = not visible


func atualizar_missoes():
	mission_list.text = ""

	for mission in missions:
		mission_list.text += mission + "\n\n"
