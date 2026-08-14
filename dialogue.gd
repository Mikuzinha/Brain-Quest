extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/DialogueLabel

# Diálogo que acontece quando o jogo começa
var falas_aula = [
	"Bom dia, turma!",
	"Hoje vamos começar uma viagem pela História.",
	"Vamos conhecer diferentes épocas, lugares e acontecimentos importantes.",
	"Para começar, vamos voltar bastante no tempo.",
	"Hoje vamos aprender sobre a Roma Antiga.",
	"E nosso primeiro destino será...",
	"O Coliseu!"
]

# Diálogo quando o jogador conversa com a professora
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

var falas = []
var fala_atual = 0


func _ready():
	falas = falas_aula
	visible = true
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

func entregar_missao():
	var mission_ui = get_parent().get_node("MissionUI")
	
	mission_ui.adicionar_missao(
	"Ecos do Coliseu",
	"Viaje até a Roma Antiga e descubra como o Coliseu era utilizado, quem participava dos eventos e qual era sua importância para a sociedade romana.."
)
	
	var notification_ui = get_parent().get_node("NotificationUI")
	notification_ui.mostrar_notificacao()

func iniciar_dialogo():
	falas = falas_professora
	fala_atual = 0
	visible = true
	get_parent().get_node("Player").can_move = false
	mostrar_fala()
