extends Node2D

@export var platform_scene: PackedScene

@onready var player = $Player
@onready var score_label = $UI/ScoreLabel
@onready var coins_label = $UI/CoinsLabel
@onready var game_over_panel = $UI/GameOverPanel
@onready var final_score_label = $UI/GameOverPanel/FinalScore
@onready var high_score_label = $UI/GameOverPanel/HighScore

var score: int = 0
var coins_earned: int = 0
var highest_y: float = 0.0
var game_over: bool = false
var platforms: Array = []

const PLATFORM_SPACING = 170.0
const BASE_PLATFORM_COUNT = 14

func _ready():
	randomize()
	game_over_panel.visible = false
	_spawn_initial_platforms()
	highest_y = player.position.y
	coins_label.text = "Монеты: " + str(GameData.coins)

func _process(_delta):
	if game_over:
		return

	if player.position.y < highest_y:
		highest_y = player.position.y
		var new_score = int(-highest_y / 8.0)
		if new_score > score:
			var diff = new_score - score
			score = new_score
			score_label.text = str(score)
			# Монеты за прогресс
			if score % 50 < diff:
				coins_earned += 1

	_generate_platforms()
	_cleanup_platforms()

	if player.position.y > highest_y + 950:
		_on_game_over()

func _spawn_initial_platforms():
	var start_plat = platform_scene.instantiate()
	start_plat.position = Vector2(360, 1050)
	add_child(start_plat)
	platforms.append(start_plat)

	for i in range(BASE_PLATFORM_COUNT):
		_add_platform(1050 - (i + 1) * PLATFORM_SPACING)

func _add_platform(y: float):
	var plat = platform_scene.instantiate()
	var x = randf_range(70, 650)

	# Сложность растёт с высотой
	var difficulty = clamp((-y) / 4000.0, 0.0, 1.0)
	var r = randf()
	if r < 0.12 + difficulty * 0.15:
		plat.platform_type = "moving"
	elif r < 0.22 + difficulty * 0.2:
		plat.platform_type = "breakable"
	else:
		plat.platform_type = "normal"

	plat.position = Vector2(x, y)
	add_child(plat)
	platforms.append(plat)

func _generate_platforms():
	var top_y = highest_y - 800
	var highest_platform_y = 999999.0
	for p in platforms:
		if is_instance_valid(p):
			highest_platform_y = min(highest_platform_y, p.position.y)

	while highest_platform_y > top_y:
		highest_platform_y -= PLATFORM_SPACING * randf_range(0.85, 1.15)
		_add_platform(highest_platform_y)

func _cleanup_platforms():
	var bottom = highest_y + 1100
	for i in range(platforms.size() - 1, -1, -1):
		var p = platforms[i]
		if is_instance_valid(p) and p.position.y > bottom:
			p.queue_free()
			platforms.remove_at(i)

func _on_game_over():
	if game_over:
		return
	game_over = true
	player.set_physics_process(false)

	GameData.add_coins(coins_earned + int(score / 100))
	if score > GameData.high_score:
		GameData.high_score = score
		GameData.save_data()

	final_score_label.text = "Счёт: " + str(score)
	high_score_label.text = "Рекорд: " + str(GameData.high_score)
	coins_label.text = "Монеты: " + str(GameData.coins)
	game_over_panel.visible = true

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
