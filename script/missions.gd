extends CanvasLayer

@onready var mission_list = $MissionList


func _ready():
	visible = false
	atualizar_missoes()


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_J:
		visible = !visible
		atualizar_missoes()


func atualizar_missoes():
	mission_list.text = ""

	if MissionManager.missions.is_empty():
		mission_list.text = "Nenhuma missão ainda."
	else:
		for mission in MissionManager.missions:
			mission_list.text += "🟡 " + mission["titulo"] + "\n"
			mission_list.text += mission["descricao"] + "\n"
			mission_list.text += "Status: " + mission["status"] + "\n\n"
