
extends CanvasLayer

@onready var label = $Panel/DialogueLabel
@onready var name_label = $Panel/NameLabel

const CENA_BATALHA = "res://battle.tscn"
const CENA_COLISEU = "res://scenes/map/coliseum.tscn"

var falas_guia = [
	"Bem-vindo ao Coliseu!",
	"Este lugar recebia grandes espetáculos públicos.",
	"Entre as atrações estavam os combates entre gladiadores.",
    "Converse com o lutador para conhecer o desafio da arena!"
]

var falas_guia_vitoria = [
	"Você conseguiu vencer o desafio da arena!",
	"Sua coragem impressionou todos no Coliseu.",
	"Agora você conhece melhor os espetáculos de Roma!",
	"Siga no portão acima para sair."
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

var falas_cidadao_vitoria = [
	"Salve, visitante!",
	"Fiquei sabendo que você venceu o desafio!",
    "Você entrou para a história do Coliseu!"
]

var falas_gladiador = [
	"Sou um gladiador do Coliseu.",
    "Os gladiadores lutavam diante do público."
]

var falas_gladiador_vitoria = [
	"Você venceu o desafio da arena!",
    "Sua coragem merece respeito."
]

var falas_imperador = [
	"Bem-vindo ao Coliseu!",
	"Sou o imperador de Roma.",
    "Este lugar recebia grandes espetáculos públicos."
]

var falas_imperador_vitoria = [
	"Parabéns pela vitória!",
	"Você demonstrou coragem e habilidade.",
    "Roma reconhece sua conquista!"
]

var falas = []
var fala_atual = 0
var tipo_atual = ""
var dialogo_ativo = false


func _ready() -> void:
	visible = false


func iniciar_dialogo_npc(tipo: String) -> void:
	print("DIÁLOGO INICIADO. TIPO RECEBIDO: ", tipo)

	if dialogo_ativo:
		return

	var batalha_vencida = GameState.batalha_vencida

	match tipo:

		"guia":
			if batalha_vencida:
				falas = falas_guia_vitoria
			else:
				falas = falas_guia

			name_label.text = "Guia"

		"lutador":
			if GameState.lutador_derrotado:
				return

			falas = falas_lutador
			name_label.text = "Lutador"

		"cidadao":
			if batalha_vencida:
				falas = falas_cidadao_vitoria
			else:
				falas = falas_cidadao

			name_label.text = "Cidadão romano"

		"gladiador":
			if batalha_vencida:
				falas = falas_gladiador_vitoria
			else:
				falas = falas_gladiador

			name_label.text = "Gladiador"

		"imperador":
			if batalha_vencida:
				falas = falas_imperador_vitoria
			else:
				falas = falas_imperador

			name_label.text = "Imperador"

		_:
			print("TIPO NÃO CONFIGURADO: ", tipo)
			return

	tipo_atual = tipo
	fala_atual = 0
	dialogo_ativo = true
	visible = true

	var player = get_tree().current_scene.find_child(
		"Player", true, false
	)

	if player:
		player.can_move = false

	mostrar_fala()


func mostrar_fala() -> void:
	if fala_atual < falas.size():
		label.text = falas[fala_atual]


func proxima_fala() -> void:
	if not dialogo_ativo:
		return

	fala_atual += 1

	if fala_atual < falas.size():
		mostrar_fala()
		return

	print("DIÁLOGO TERMINOU. TIPO: ", tipo_atual)

	dialogo_ativo = false
	visible = false

	if tipo_atual == "lutador":
		abrir_batalha()
	else:
		liberar_jogador()


func _input(event: InputEvent) -> void:
	if not dialogo_ativo:
		return

	if event.is_action_pressed("ui_accept") and not event.is_echo():
		get_viewport().set_input_as_handled()
		proxima_fala()


func liberar_jogador() -> void:
	var player = get_tree().current_scene.find_child(
		"Player", true, false
	)

	if player:
		player.can_move = true


func abrir_batalha() -> void:
	print("TENTANDO ABRIR BATALHA: ", CENA_BATALHA)

	if not ResourceLoader.exists(CENA_BATALHA):
		print("ERRO: CAMINHO DA BATALHA NÃO EXISTE!")
		return

	var player = get_tree().current_scene.find_child(
		"Player", true, false
	)

	if player:
		GameState.posicao_retorno = player.global_position
		GameState.retornar_posicao = true

		print("POSIÇÃO SALVA: ", GameState.posicao_retorno)
	else:
		print("ERRO: PLAYER NÃO ENCONTRADO!")

	var resultado = get_tree().change_scene_to_file(CENA_BATALHA)

	if resultado != OK:
		print("ERRO AO TROCAR DE CENA: ", resultado)
