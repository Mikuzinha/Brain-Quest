extends Control

var player_hp = 100
var player_max_hp = 100

var enemy_hp = 100
var enemy_max_hp = 100

var player_stamina = 20
var player_max_stamina = 20

var defending = false
var player_turn = true
var waiting_for_message = false
var message_step = 0
var invincible_defense = false


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

@onready var defeat_screen = $DefeatScreen
@onready var victory_screen = $VictoryScreen
@onready var victory_button = $VictoryScreen/ContinueButton
@onready var defeat_button = $DefeatScreen/ContinueButton
@onready var defeat_title = $DefeatScreen/DefeatTitle
@onready var defeat_description = $DefeatScreen/DefeatDescription

@onready var animacao_player: AnimatedSprite2D = $Protagonista/AnimatedSprite2D
@onready var animacao_inimigo: AnimatedSprite2D = $Inimigo/AnimatedSprite2D

func _ready() -> void:
	update_ui()
	set_stamina_bar_color()

	# Começa com o botão Atacar selecionado
	$ActionMenu/GridContainer/AttackButton.grab_focus()



func update_ui() -> void:

	enemy_hp_text.text = "HP: %d/%d" % [enemy_hp, enemy_max_hp]
	player_hp_text.text = "HP: %d/%d" % [player_hp, player_max_hp]

	stamina_text.text = "ST: %d/%d" % [player_stamina, player_max_stamina]
	stamina_bar.value = player_stamina

	animate_hp_bar(enemy_hp_bar, enemy_hp, enemy_max_hp)
	animate_hp_bar(player_hp_bar, player_hp, player_max_hp)



func animate_hp_bar(bar: ProgressBar, target_hp: int, max_hp: int) -> void:

	var tween = create_tween()

	tween.tween_property(
		bar,
		"value",
		target_hp,
		0.8
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	set_hp_bar_color(bar, target_hp, max_hp)


func set_hp_bar_color(bar: ProgressBar, hp: int, max_hp: int) -> void:

	var style = StyleBoxFlat.new()
	var percentage = float(hp) / float(max_hp)

	if percentage > 0.6:
		style.bg_color = Color("#4CAF50")

	elif percentage > 0.3:
		style.bg_color = Color("#FFC107")

	else:
		style.bg_color = Color("#F44336")

	bar.add_theme_stylebox_override("fill", style)



func _on_attack_button_pressed() -> void:

	if not player_turn:
		return

	player_turn = false
	await animar_ataque_player()

	# Causa 20 de dano
	enemy_hp = max(enemy_hp - 20, 0)

	update_ui()

	if enemy_hp <= 0:
		show_victory()
		return

		set_battle_buttons_enabled(false)
		return

	# Mostra mensagem do jogador
	show_guide(
		"VOCÊ ATACOU!",
		"Causou 20 de dano.\nPressione E para continuar."
	)

	# Bloqueia as setas
	set_battle_buttons_enabled(false)

	waiting_for_message = true
	message_step = 0


func _on_defend_button_pressed() -> void:

	if not player_turn:
		return

	player_turn = false

	# Ativa defesa
	defending = true

	# Recupera 5 de stamina
	player_stamina = min(
		player_stamina + 5,
		player_max_stamina
	)

	update_ui()

	show_guide(
		"VOCÊ DEFENDEU!",
		"Você recuperou 5 de stamina.\nPressione E para continuar."
	)

	set_battle_buttons_enabled(false)

	waiting_for_message = true
	message_step = 0


func enemy_attack() -> int:

	await animar_ataque_inimigo()

	var damage = 20

	# Defesa Inabalável
	if invincible_defense:

		damage = 0
		invincible_defense = false

	# Defesa normal
	elif defending:

		damage = 10
		defending = false

	player_hp = max(player_hp - damage, 0)

	update_ui()

	if player_hp <= 0:
		show_defeat()

	return damage


func show_guide(title: String, description: String) -> void:

	guide_title.text = title
	guide_description.text = description



func _on_attack_button_focus_entered() -> void:

	if waiting_for_message:
		return

	show_guide(
		"ATACAR",
		"Causa 20 de dano.\nNão consome stamina."
	)


func _on_defend_button_focus_entered() -> void:

	if waiting_for_message:
		return

	show_guide(
		"DEFENDER",
		"Reduz o próximo dano em 50%.\nRecupera 5 de stamina."
	)


func _on_item_button_focus_entered() -> void:

	if waiting_for_message:
		return

	show_guide(
		"ITEM",
		"Você ainda não tem nenhum item."
	)


func _on_skill_button_focus_entered() -> void:

	if waiting_for_message:
		return

	show_guide(
		"HABILIDADE",
		"Escolha uma habilidade.\nCada habilidade possui um custo de stamina."
	)


func _on_skill_button_pressed() -> void:

	if not player_turn:
		return

	action_menu.visible = false
	skill_menu.visible = true

	powerful_attack_button.grab_focus()


func _on_powerful_attack_button_pressed() -> void:

	if not player_turn:
		return

	# Verifica stamina
	if player_stamina < 10:

		show_guide(
			"GOLPE PODEROSO",
			"Stamina insuficiente.\nCusto: 10 ST."
		)

		return

	# Gasta 10 stamina
	player_stamina -= 10

	# Causa 40 de dano
	enemy_hp = max(enemy_hp - 40, 0)

	# Fecha habilidades
	skill_menu.visible = false
	action_menu.visible = true

	update_ui()

	# Vitória
	if enemy_hp <= 0:
		show_victory()
		return

	player_turn = false

	show_guide(
		"GOLPE PODEROSO!",
		"Causou 40 de dano.\nPressione E para continuar."
	)

	set_battle_buttons_enabled(false)

	waiting_for_message = true
	message_step = 0


func _on_invincible_defense_button_pressed() -> void:

	if not player_turn:
		return

	# Verifica stamina
	if player_stamina < 5:

		show_guide(
			"DEFESA INABALÁVEL",
			"Stamina insuficiente.\nCusto: 5 ST."
		)

		return

	# Gasta 5 stamina
	player_stamina -= 5

	# Próximo ataque causa 0
	invincible_defense = true

	# Fecha menu de habilidades
	skill_menu.visible = false
	action_menu.visible = true

	update_ui()

	player_turn = false

	show_guide(
		"DEFESA INABALÁVEL!",
		"O próximo ataque recebido causará 0 de dano.\nPressione E para continuar."
	)

	set_battle_buttons_enabled(false)

	waiting_for_message = true
	message_step = 0



func _on_powerful_attack_button_focus_entered() -> void:

	if waiting_for_message:
		return

	show_guide(
		"GOLPE PODEROSO",
		"Causa 40 de dano.\nCusta 10 de stamina."
	)


func _on_invincible_defense_button_focus_entered() -> void:

	if waiting_for_message:
		return

	show_guide(
		"DEFESA INABALÁVEL",
		"O próximo ataque recebido causa 0 de dano.\nCusta 5 de stamina."
	)



func _input(event: InputEvent) -> void:

	# ESC
	if event.is_action_pressed("ui_cancel"):

		if skill_menu.visible:

			skill_menu.visible = false
			action_menu.visible = true

			$ActionMenu/GridContainer/SkillButton.grab_focus()

			get_viewport().set_input_as_handled()

			return



	if event.is_action_pressed("continue_battle"):

		if not waiting_for_message:
			return



		if message_step == 0:

			var damage = await enemy_attack()

			show_guide(
				"O INIMIGO ATACOU!",
				"Causou %d de dano.\nPressione E para continuar." % damage
			)

			message_step = 1

			get_viewport().set_input_as_handled()

			return


		elif message_step == 1:

			waiting_for_message = false
			message_step = 0

			player_turn = true

			set_battle_buttons_enabled(true)

			show_guide(
				"ATACAR",
				"Causa 20 de dano.\nNão consome stamina."
			)

			$ActionMenu/GridContainer/AttackButton.grab_focus()

			get_viewport().set_input_as_handled()

			return


	# BLOQUEAR SETAS E ENTER DURANTE AS MENSAGENS

	if waiting_for_message:

		get_viewport().set_input_as_handled()

		return


# BLOQUEAR / LIBERAR BOTÕES

func set_battle_buttons_enabled(enabled: bool) -> void:

	if enabled:

		$ActionMenu/GridContainer/AttackButton.focus_mode = Control.FOCUS_ALL
		$ActionMenu/GridContainer/DefendButton.focus_mode = Control.FOCUS_ALL
		$ActionMenu/GridContainer/ItemButton.focus_mode = Control.FOCUS_ALL
		$ActionMenu/GridContainer/SkillButton.focus_mode = Control.FOCUS_ALL

		powerful_attack_button.focus_mode = Control.FOCUS_ALL
		invincible_defense_button.focus_mode = Control.FOCUS_ALL

	else:

		$ActionMenu/GridContainer/AttackButton.focus_mode = Control.FOCUS_NONE
		$ActionMenu/GridContainer/DefendButton.focus_mode = Control.FOCUS_NONE
		$ActionMenu/GridContainer/ItemButton.focus_mode = Control.FOCUS_NONE
		$ActionMenu/GridContainer/SkillButton.focus_mode = Control.FOCUS_NONE

		powerful_attack_button.focus_mode = Control.FOCUS_NONE
		invincible_defense_button.focus_mode = Control.FOCUS_NONE


# STAMINA

func set_stamina_bar_color() -> void:

	var style = StyleBoxFlat.new()

	style.bg_color = Color("#2196F3")

	stamina_bar.add_theme_stylebox_override(
		"fill",
		style
	)

func show_defeat() -> void:

	player_turn = false
	waiting_for_message = false

	set_battle_buttons_enabled(false)

	action_menu.visible = false
	skill_menu.visible = false

	defeat_screen.visible = true

	defeat_button.grab_focus()

func show_victory() -> void:

	player_turn = false
	waiting_for_message = false

	set_battle_buttons_enabled(false)

	action_menu.visible = false
	skill_menu.visible = false

	victory_screen.visible = true

	victory_button.grab_focus()

func _on_victory_continue_button_pressed() -> void:
	print("BOTÃO CONTINUAR CLICADO!")

	GameState.batalha_vencida = true
	GameState.lutador_derrotado = true

	var resultado = get_tree().change_scene_to_file(
        "res://assets/maps/coliseum_interior.tscn"
	)

	print("RESULTADO DA TROCA DE CENA: ", resultado)


func _on_defeat_continue_button_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://scenes/map/coliseum.tscn"
	)
	
func animar_ataque_player() -> void:
	animacao_player.play("attack")
	await animacao_player.animation_finished
	animacao_player.play("idle")


func animar_ataque_inimigo() -> void:
	animacao_inimigo.play("attack")
	await animacao_inimigo.animation_finished
	animacao_inimigo.play("idle")
