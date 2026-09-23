extends CanvasLayer

@onready var label = $Panel/DialogueLabel
@onready var name_label = $Panel/NameLabel

var falas = []
var fala_atual = 0


func _ready():
	visible = false


func _input(event):
	if event.is_action_pressed("ui_accept") and visible:
		proxima_fala()


func mostrar_fala():
	label.text = falas[fala_atual]


func proxima_fala():
	fala_atual += 1

	if fala_atual >= falas.size():
		visible = false
		get_parent().get_node("Player").can_move = true
	else:
		mostrar_fala()


func iniciar_dialogo_npc(tipo):
	if tipo == "gladiador":
		falas = [
			"Eu luto nesta arena diante de uma multidão.",
			"Muitos gladiadores são treinados em escolas especiais,",
			"para aprender a lutar.",
			"Entre no Coliseu, e enfrete-o se for capaz."
		]
		name_label.text = "Gladiador"

	elif tipo == "cidadao":
		falas = [
			"Você sabia que este lugar consegue receber,",
			"milhares de pessoas?",
			"As arquibancadas são organizadas de acordo,",
			"com a posição social de cada pessoa."
		]
		name_label.text = "Cidadão"

	elif tipo == "imperador":
		falas = [
			"O Coliseu demonstra o poder de Roma.",
			"Imperadores promovem grandes eventos,",
			"para conquistar prestígio e manter sua,",
			"relação com o povo."
		]
		name_label.text = "Imperador"

	fala_atual = 0
	visible = true
	get_parent().get_node("Player").can_move = false
	mostrar_fala()
