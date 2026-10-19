extends CanvasLayer

@onready var label = $Panel/DialogueLabel
@onready var name_label = $Panel/NameLabel

const CENA_BATALHA = "res://battle.tscn"

var falas_guia = [
	"Bem-vindo ao Coliseu!",
	"Este lugar recebia grandes espetáculos públicos.",
	"Entre as atrações estavam os combates entre gladiadores.",
	"Converse com o lutador para conhecer o desafio da arena!"
]

var falas_lutador = [
	"Então você quer entrar na arena?",
	"Os gladiadores participavam de combates públicos.",
	"Prepare-se para o desafio!",
	"Vamos começar!"
]

var falas_cidadao = [
	"Salve, visitante!",
	"Sou um cidadão de Roma.",
	"O Coliseu era um importante espaço de entretenimento público.",
	"Lá aconteciam combates e outros espetáculos."
]

var falas_gladiador = [
	"Sou um gladiador do Coliseu.",
	"Os gladiadores lutavam diante do público."
]

var falas_imperador = [
	"Bem-vindo ao Coliseu!",
	"Sou o imperador de Roma.",
	"Este lugar recebia grandes espetáculos públicos."
]

var falas = []
var fala_atual = 0
var tipo_atual = ""

func _ready() -> void:
	visible = false

func iniciar_dialogo_npc(tipo: String) -> void:
	match tipo:
		"guia":
			falas = falas_guia
			name_label.text = "Guia"
		"lutador":
			falas = falas_lutador
			name_label.text = "Lutador"
		"cidadao":
			falas = falas_cidadao
			name_label.text = "Cidadão romano"
		"gladiador":
			falas = falas_gladiador
			name_label.text = "Gladiador"
		"imperador":
			falas = falas_imperador
			name_label.text = "Imperador"
		_:
			print("Tipo de NPC desconhecido: ", tipo)
			return

	tipo_atual = tipo
	fala_atual = 0
	visible = true

	var player = get_tree().current_scene.find_child("Player", true, false)
	if player:
		player.can_move = false

	mostrar_fala()

func mostrar_fala() -> void:
	if fala_atual < falas.size():
		label.text = falas[fala_atual]

func proxima_fala() -> void:
	fala_atual += 1

	if fala_atual >= falas.size():
		var iniciar_batalha = tipo_atual == "lutador"

		visible = false

		var player = get_tree().current_scene.find_child("Player", true, false)
		if player:
			player.can_move = true

		if iniciar_batalha:
			abrir_batalha()
	else:
		mostrar_fala()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept") and not event.is_echo():
		get_viewport().set_input_as_handled()
		proxima_fala()

func abrir_batalha() -> void:
	if not ResourceLoader.exists(CENA_BATALHA):
		print("ERRO: cena de batalha não encontrada: ", CENA_BATALHA)
		return

	get_tree().change_scene_to_file(CENA_BATALHA)
