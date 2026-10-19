extends CanvasLayer

@onready var label = $Panel/DialogueLabel

var falas: Array[String] = []
var fala_atual: int = 0
var dialogo_ativo: bool = false
var tipo_dialogo: String = ""

var falas_aula: Array[String] = [
	"Bom dia, turma!",
	"Hoje vamos começar uma viagem pela História.",
	"Vamos conhecer diferentes épocas, lugares e acontecimentos importantes.",
	"Para começar, vamos voltar bastante no tempo.",
	"Hoje vamos aprender sobre a Roma Antiga.",
	"E nosso primeiro destino será...",
	"O Coliseu!"
]

var falas_professora: Array[String] = [
	"Ah, você quer começar sua primeira missão?",
	"Então vamos conhecer o Coliseu.",
	"Ele ficava em Roma.",
	"Quero que você descubra como ele era utilizado",
	"e qual era sua importância para os romanos.",
	"Viaje até a Roma Antiga,",
	"explore o Coliseu e descubra essas informações.",
	"Quando terminar sua investigação,",
	"volte para mim."
]

func _ready() -> void:
	visible = true
	iniciar_dialogo_aula()

func iniciar_dialogo_aula() -> void:
	falas = falas_aula.duplicate()
	fala_atual = 0
	tipo_dialogo = "aula"
	dialogo_ativo = true
	visible = true
	bloquear_jogador()
	mostrar_fala()

func iniciar_dialogo() -> void:
	if dialogo_ativo:
		return

	falas = falas_professora.duplicate()
	fala_atual = 0
	tipo_dialogo = "professora"
	dialogo_ativo = true
	visible = true
	bloquear_jogador()
	mostrar_fala()

func bloquear_jogador() -> void:
	var player = get_tree().current_scene.find_child("Player", true, false)

	if player:
		player.can_move = false

func liberar_jogador() -> void:
	var player = get_tree().current_scene.find_child("Player", true, false)

	if player:
		player.can_move = true

func _input(event: InputEvent) -> void:
	if not dialogo_ativo:
		return

	if event.is_action_pressed("ui_accept") and not event.is_echo():
		get_viewport().set_input_as_handled()
		proxima_fala()

func mostrar_fala() -> void:
	if fala_atual < falas.size():
		label.text = falas[fala_atual]

func proxima_fala() -> void:
	fala_atual += 1

	if fala_atual >= falas.size():
		var dialogo_que_terminou = tipo_dialogo

		dialogo_ativo = false
		visible = false
		liberar_jogador()

		if dialogo_que_terminou == "professora":
			ativar_portal()
	else:
		mostrar_fala()

func ativar_portal() -> void:
	var portal = get_tree().current_scene.find_child(
		"TimePortal", true, false
	)

	if portal:
		portal.ativar_portal()
		print("Portal encontrado e ativado!")
	else:
		print("ERRO: não encontrei o nó TimePortal!")
