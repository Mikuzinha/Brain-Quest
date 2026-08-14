extends CanvasLayer

@onready var mission_list = $MissionList

var missions = []


func _ready():
	visible = false
	atualizar_missoes()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_J:
			visible = not visible


func atualizar_missoes():
	mission_list.text = ""

	if missions.is_empty():
		mission_list.text = "Nenhuma missão ainda."
	else:
		for mission in missions:
			mission_list.text += "🟡 " + mission["titulo"] + "\n"
			mission_list.text += mission["descricao"] + "\n"
			mission_list.text += "Status: " + mission["status"] + "\n\n"


func adicionar_missao(titulo, descricao):
	var nova_missao = {
		"titulo": titulo,
		"descricao": descricao,
		"status": "EM ANDAMENTO"
	}
	
	missions.append(nova_missao)
	atualizar_missoes()
