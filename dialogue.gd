extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/DialogueLabel

var falas = [
	"Bom dia, turma!",
	"Hoje vamos aprender um pouco", 
	"sobre a Segunda Guerra Mundial.",
	"Prestem bastante atenção, porque", 
	"no final da aula vocês terão uma missão.",
	"Quando terminarmos, vocês", 
	"poderão explorar a sala."
]

var fala_atual = 0


func _ready():
	visible = true
	mostrar_fala()


func _input(event):
	if event.is_action_pressed("ui_accept"):
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
