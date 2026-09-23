extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/DialogueLabel


var falas_aula = [
	"Bom dia, turma!",
	"Hoje vamos começar uma viagem pela História.",
	"Vamos conhecer diferentes épocas, lugares e acontecimentos importantes.",
	"Para começar, vamos voltar bastante no tempo.",
	"Hoje vamos aprender sobre a Roma Antiga.",
	"E nosso primeiro destino será...",
	"O Coliseu!"
]


var falas_professora = [
	"Ah, você quer começar sua primeira missão?",
	"Então vamos conhecer o Coliseu.",
	"Ele ficava em Roma",
	"Quero que você descubra como ele era utilizado",
	"e qual era sua importância para os romanos.",
	"Viaje até a Roma Antiga,",
	"explore o Coliseu e descubra essas informações.",
	"Quando terminar sua investigação",
	"volte para mim."
]


var falas_gladiador = [
	"Eu luto aqui diante de milhares de pessoas.",
	"Os combates entre gladiadores são uma das atrações do Coliseu."
]


var falas_cidadao = [
	"O Coliseu recebe muitos espetáculos.",
	"É um lugar onde muitos romanos vêm se divertir."
]


var falas_imperador = [
	"Eu venho ao Coliseu para assistir aos grandes espetáculos.",
	"É impressionante ver tantos romanos reunidos neste lugar."
]


var falas = []
var fala_atual = 0


func _ready():
	falas = falas_aula
	visible = true
	get_parent().get_node("Player").can_move = false
	mostrar_fala()


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
		
		if falas == falas_professora:
			entregar_missao()
	else:
		mostrar_fala()


func iniciar_dialogo():
	falas = falas_professora
	fala_atual = 0
	visible = true
	get_parent().get_node("Player").can_move = false
	mostrar_fala()


func iniciar_dialogo_npc(tipo):
	if tipo == "gladiador":
		falas = falas_gladiador
	
	elif tipo == "cidadao":
		falas = falas_cidadao
	
	elif tipo == "imperador":
		falas = falas_imperador

	fala_atual = 0
	visible = true
	get_parent().get_node("Player").can_move = false
	mostrar_fala()


func entregar_missao():
	MissionManager.adicionar_missao(
		"Ecos do Coliseu",
		"Viaje até a Roma Antiga e descubra como o Coliseu era utilizado e qual era sua importância para os romanos."
	)
	
	var portal = get_parent().get_node("TimePortal")
	portal.ativar_portal()
	
	var notification_ui = get_parent().get_node("NotificationUI")
	notification_ui.mostrar_notificacao()
