
extends Control

var player_hp: int = 100
var player_max_hp: int = 100

var enemy_hp: int = 200
var enemy_max_hp: int = 200

var player_stamina: int = 20
var player_max_stamina: int = 20

var defending: bool = false
var enemy_defending: bool = false
var invincible_defense: bool = false

var player_turn: bool = true
var waiting_for_message: bool = false
var message_step: int = 0
var animating_action: bool = false

var quiz_started: bool = false
var quiz_intro_pending: bool = false
var quiz_question_index: int = 0

var quiz_questions = [
	{
		"question": "Qual era a principal função do Coliseu?",
		"options": [
			"Combates e espetáculos",
			"Ensinar crianças",
			"Armazenar alimentos",
			"Local de festas"
		],
		"correct": 0
	},
	{
		"question": "Como eram chamados as pessoas que lutavam no Coliseu?",
		"options": [
			"Senadores",
			"Gladiadores",
			"Legionários",
			"Tribunos"
		],
		"correct": 1
	},
	{
		"question": "Qual era a língua predominante na Roma Antiga?",
		"options": [
			"O Espanhol",
			"O Português",
			"O Latim",
			"O Italiano"
		],
		"correct": 2
	},
	{
		"question": "Onde ocorriam os combates de gladiadores?",
		"options": [
			"No Teatro",
			"No Coliseu",
			"Em Templos",
			"Na rua"
		],
		"correct": 1
	},
	{
		"question": "Quem governava Roma durante o período imperial?",
		"options": [
			"Imperador",
			"Gladiador",
			"Vendedor",
			"Presidente"
		],
		"correct": 0
	}
]

var quiz_button_nodes = []

@onready var enemy_name = $EnemyInfo/EnemyName
@onready var enemy_hp_text = $EnemyInfo/EnemyHP
@onready var enemy_hp_bar = $EnemyInfo/EnemyHPBar

@onready var player_hp_text = $PlayerInfo/PlayerHP
@onready var player_hp_bar = $PlayerInfo/PlayerHPBar
@onready var stamina_text = $PlayerInfo/StaminaText
@onready var stamina_bar = $PlayerInfo/StaminaBar

@onready var guide_title = $ActionGuide/GuideTitle
@onready var guide_description = $ActionGuide/GuideDescription

@onready var action_menu = $ActionMenu
@onready var skill_menu = $SkillMenu

@onready var powerful_attack_button = $SkillMenu/VBoxContainer/PowerfulAttackButton
@onready var invincible_defense_button = $SkillMenu/VBoxContainer/InvincibleDefenseButton

@onready var victory_screen = $VictoryScreen
@onready var defeat_screen = $DefeatScreen
@onready var victory_button = $VictoryScreen/ContinueButton
@onready var defeat_button = $DefeatScreen/ContinueButton


func _ready() -> void:
	enemy_name.text = "Professora"

	enemy_hp_bar.max_value = enemy_max_hp
	player_hp_bar.max_value = player_max_hp
	stamina_bar.max_value = player_max_stamina

	quiz_button_nodes = [
		$ActionMenu/GridContainer/AttackButton,
		$ActionMenu/GridContainer/DefendButton,
		$ActionMenu/GridContainer/ItemButton,
		$ActionMenu/GridContainer/SkillButton
	]

	update_ui()
	set_stamina_bar_color()

	skill_menu.visible = false
	victory_screen.visible = false
	defeat_screen.visible = false

	set_battle_buttons_enabled(true)

	show_guide("PROFESSORA", "Vamos ver o que você aprendeu em Roma!")
	$ActionMenu/GridContainer/AttackButton.grab_focus()


func update_ui() -> void:
	enemy_hp_text.text = "HP: %d/%d" % [enemy_hp, enemy_max_hp]
	player_hp_text.text = "HP: %d/%d" % [player_hp, player_max_hp]
	stamina_text.text = "ST: %d/%d" % [player_stamina, player_max_stamina]

	stamina_bar.value = player_stamina

	animate_hp_bar(enemy_hp_bar, enemy_hp, enemy_max_hp)
	animate_hp_bar(player_hp_bar, player_hp, player_max_hp)


func animate_hp_bar(bar: ProgressBar, target_hp: int, max_hp: int) -> void:
	var old_tween = bar.get_meta("hp_tween", null)
	if old_tween is Tween and old_tween.is_running():
		old_tween.kill()

	var tween = create_tween()
	bar.set_meta("hp_tween", tween)

	tween.tween_property(
		bar,
		"value",
		target_hp,
		0.8
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	set_hp_bar_color(bar, target_hp, max_hp)


func set_hp_bar_color(bar: ProgressBar, hp: int, max_hp: int) -> void:
	var style = StyleBoxFlat.new()
	var percentage = float(hp) / float(max_hp) if max_hp > 0 else 0.0

	if percentage > 0.6:
		style.bg_color = Color("#4CAF50")
	elif percentage > 0.3:
		style.bg_color = Color("#FFC107")
	else:
		style.bg_color = Color("#F44336")

	bar.add_theme_stylebox_override("fill", style)


func set_stamina_bar_color() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#2196F3")
	stamina_bar.add_theme_stylebox_override("fill", style)


func show_guide(title: String, description: String) -> void:
	guide_title.text = title
	guide_description.text = description


func begin_message() -> void:
	set_battle_buttons_enabled(false)
	waiting_for_message = true
	message_step = 0


# ATAQUE NORMAL
func _on_attack_button_pressed() -> void:
	if quiz_started:
		answer_quiz(0)
		return

	if not player_turn or waiting_for_message or animating_action:
		return

	player_turn = false
	animating_action = true

	var damage := 20
	if enemy_defending:
		damage = 10
		enemy_defending = false

	enemy_hp = max(enemy_hp - damage, 0)
	update_ui()

	await get_tree().create_timer(0.25).timeout
	animating_action = false

	if enemy_hp <= 0:
		show_victory()
		return

	if enemy_hp <= 100:
		start_quiz()
		return

	show_guide("VOCÊ ATACOU!", "Causou %d de dano.\nPressione E para continuar." % damage)
	begin_message()


# DEFESA NORMAL
func _on_defend_button_pressed() -> void:
	if quiz_started:
		answer_quiz(1)
		return

	if not player_turn or waiting_for_message or animating_action:
		return

	player_turn = false
	defending = true
	player_stamina = min(player_stamina + 5, player_max_stamina)
	update_ui()

	show_guide("VOCÊ DEFENDEU!", "Recuperou 5 de stamina.\nPressione E para continuar.")
	begin_message()


# ABRIR HABILIDADES
func _on_skill_button_pressed() -> void:
	if quiz_started:
		answer_quiz(3)
		return

	if not player_turn or waiting_for_message or animating_action:
		return

	action_menu.visible = false
	skill_menu.visible = true
	powerful_attack_button.grab_focus()


# GOLPE PODEROSO
func _on_powerful_attack_button_pressed() -> void:
	if not player_turn or waiting_for_message or animating_action or quiz_started:
		return

	if player_stamina < 10:
		show_guide("GOLPE PODEROSO", "Stamina insuficiente.\nCusto: 10 ST.")
		return

	player_turn = false
	animating_action = true
	player_stamina -= 10

	var damage := 40
	if enemy_defending:
		damage = 20
		enemy_defending = false

	enemy_hp = max(enemy_hp - damage, 0)

	skill_menu.visible = false
	action_menu.visible = true
	update_ui()

	await get_tree().create_timer(0.25).timeout
	animating_action = false

	if enemy_hp <= 0:
		show_victory()
		return

	if enemy_hp <= 100:
		start_quiz()
		return

	show_guide("GOLPE PODEROSO!", "Causou %d de dano.\nPressione E para continuar." % damage)
	begin_message()


# DEFESA INABALÁVEL
func _on_invincible_defense_button_pressed() -> void:
	if not player_turn or waiting_for_message or animating_action or quiz_started:
		return

	if player_stamina < 5:
		show_guide("DEFESA INABALÁVEL", "Stamina insuficiente.\nCusto: 5 ST.")
		return

	player_turn = false
	player_stamina -= 5
	invincible_defense = true

	skill_menu.visible = false
	action_menu.visible = true
	update_ui()

	show_guide("DEFESA INABALÁVEL!", "O próximo ataque recebido causará 0 de dano.\nPressione E para continuar.")
	begin_message()


# CONTINUAR DIÁLOGOS E QUIZ
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and skill_menu.visible and not waiting_for_message:
		skill_menu.visible = false
		action_menu.visible = true
		$ActionMenu/GridContainer/SkillButton.grab_focus()
		get_viewport().set_input_as_handled()
		return

	if not event.is_action_pressed("continue_battle"):
		return

	if animating_action:
		get_viewport().set_input_as_handled()
		return

	if quiz_started and waiting_for_message:
		waiting_for_message = false

		if quiz_intro_pending:
			quiz_intro_pending = false
		else:
			quiz_question_index = (quiz_question_index + 1) % quiz_questions.size()

		player_turn = true
		show_quiz_question()
		get_viewport().set_input_as_handled()
		return

	if not waiting_for_message:
		return

	if message_step == 0:
		enemy_turn()
		message_step = 1
	elif message_step == 1:
		waiting_for_message = false
		message_step = 0
		player_turn = true
		set_battle_buttons_enabled(true)
		show_guide("ATACAR", "Causa 20 de dano.\nNão consome stamina.")
		$ActionMenu/GridContainer/AttackButton.grab_focus()

	get_viewport().set_input_as_handled()


# TURNO DA PROFESSORA
func enemy_turn() -> void:
	if quiz_started or enemy_hp <= 0 or player_hp <= 0:
		return

	var choice := randi_range(0, 9)

	if choice < 3:
		enemy_defending = true
		show_guide("A PROFESSORA SE DEFENDEU!", "Ela está preparada para o próximo ataque.\nPressione E para continuar.")
		return

	var damage := 20

	if invincible_defense:
		damage = 0
		invincible_defense = false
	elif defending:
		damage = 10
		defending = false

	player_hp = max(player_hp - damage, 0)
	update_ui()

	await get_tree().create_timer(0.25).timeout

	if player_hp <= 0:
		show_defeat()
		return

	show_guide("A PROFESSORA ATACOU!", "Causou %d de dano.\nPressione E para continuar." % damage)


# HABILITAR OU DESABILITAR BOTÕES
func set_battle_buttons_enabled(enabled: bool) -> void:
	var buttons = [
		$ActionMenu/GridContainer/AttackButton,
		$ActionMenu/GridContainer/DefendButton,
		$ActionMenu/GridContainer/ItemButton,
		$ActionMenu/GridContainer/SkillButton,
		powerful_attack_button,
		invincible_defense_button
	]

	for button in buttons:
		button.disabled = not enabled
		button.focus_mode = Control.FOCUS_ALL if enabled else Control.FOCUS_NONE


# VITÓRIA
func show_victory() -> void:
	player_turn = false
	waiting_for_message = false
	animating_action = false
	set_battle_buttons_enabled(false)
	action_menu.visible = false
	skill_menu.visible = false
	victory_screen.visible = true
	victory_button.grab_focus()


# DERROTA
func show_defeat() -> void:
	player_turn = false
	waiting_for_message = false
	animating_action = false
	set_battle_buttons_enabled(false)
	action_menu.visible = false
	skill_menu.visible = false
	defeat_screen.visible = true
	defeat_button.grab_focus()


# ITEM E TEXTOS DE AJUDA
func _on_attack_button_focus_entered() -> void:
	if not waiting_for_message and not quiz_started:
		show_guide("ATACAR", "Causa 20 de dano.\nNão consome stamina.")


func _on_defend_button_focus_entered() -> void:
	if not waiting_for_message and not quiz_started:
		show_guide("DEFENDER", "Reduz o próximo dano em 50%.\nRecupera 5 de stamina.")


func _on_skill_button_focus_entered() -> void:
	if not waiting_for_message and not quiz_started:
		show_guide("HABILIDADE", "Escolha uma habilidade.\nCada habilidade possui um custo de stamina.")


func _on_item_button_focus_entered() -> void:
	if not waiting_for_message and not quiz_started:
		show_guide("ITEM", "Você ainda não tem nenhum item.")


func _on_powerful_attack_button_focus_entered() -> void:
	if not waiting_for_message and not quiz_started:
		show_guide("GOLPE PODEROSO", "Causa 40 de dano.\nCusta 10 de stamina.")


func _on_invincible_defense_button_focus_entered() -> void:
	if not waiting_for_message and not quiz_started:
		show_guide("DEFESA INABALÁVEL", "O próximo ataque recebido causa 0 de dano.\nCusta 5 de stamina.")


func _on_item_button_pressed() -> void:
	if quiz_started:
		if not player_turn or waiting_for_message:
			return
		answer_quiz(2)
		return

	if not player_turn or waiting_for_message:
		return

	show_guide("ITEM", "Você ainda não tem nenhum item.")


func _on_victory_continue_button_pressed() -> void:
	pass


func _on_defeat_continue_button_pressed() -> void:
	pass


# COMEÇAR A FASE DO QUIZ
func start_quiz() -> void:
	quiz_started = true
	quiz_intro_pending = true
	player_turn = false
	waiting_for_message = true
	message_step = 0
	animating_action = false

	skill_menu.visible = false
	action_menu.visible = true
	set_battle_buttons_enabled(false)

	show_guide("PROFESSORA", "Aparentemente, você sabe lutar muito bem... Mas será que realmente aprendeu alguma coisa com tudo isso?")


# MOSTRAR PERGUNTA E ALTERNATIVAS
func show_quiz_question() -> void:
	if quiz_question_index >= quiz_questions.size():
		quiz_question_index = 0

	var question = quiz_questions[quiz_question_index]

	for i in range(quiz_button_nodes.size()):
		quiz_button_nodes[i].text = question["options"][i]

	action_menu.visible = true
	skill_menu.visible = false
	set_battle_buttons_enabled(true)

	show_guide("PERGUNTA %d" % [quiz_question_index + 1], question["question"])
	quiz_button_nodes[0].grab_focus()


# VERIFICAR RESPOSTA DO QUIZ
func answer_quiz(option_index: int) -> void:
	if not quiz_started or not player_turn or waiting_for_message:
		return

	player_turn = false
	var question = quiz_questions[quiz_question_index]

	if option_index == question["correct"]:
		enemy_hp = max(enemy_hp - 30, 0)
		update_ui()

		if enemy_hp <= 0:
			show_victory()
			return

		show_guide("RESPOSTA CORRETA!", "Você acertou! A professora perdeu 30 HP.\nPressione E para continuar.")
	else:
		player_hp = max(player_hp - 10, 0)
		update_ui()

		if player_hp <= 0:
			show_defeat()
			return

		show_guide("RESPOSTA ERRADA!", "Você perdeu 10 HP. Preste atenção!\nPressione E para continuar.")

	waiting_for_message = true
	set_battle_buttons_enabled(false)
