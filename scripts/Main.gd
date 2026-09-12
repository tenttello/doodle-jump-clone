extends Node2D

@export var platform_scene: PackedScene

@onready var player = $Player
@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel

var score: int = 0
var highest_y: float = 0.0
var game_over: bool = false
var platforms: Array = []

const PLATFORM_COUNT = 12
const PLATFORM_SPACING = 180.0

func _ready():
	randomize()
	_spawn_initial_platforms()
	highest_y = player.position.y

func _process(_delta):
	if game_over:
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_R):
			get_tree().reload_current_scene()
		return

	# Счёт по высоте
	if player.position.y < highest_y:
		highest_y = player.position.y
		score = int(-highest_y / 10.0)
		score_label.text = str(score)

	# Генерация новых платформ сверху
	_generate_platforms()

	# Удаление старых платформ снизу
	_cleanup_platforms()

	# Проигрыш
	if player.position.y > highest_y + 900:
		_on_game_over()

func _spawn_initial_platforms():
	# Стартовая платформа под игроком
	var start_plat = platform_scene.instantiate()
	start_plat.position = Vector2(360, 1000)
	add_child(start_plat)
	platforms.append(start_plat)

	for i in range(PLATFORM_COUNT):
		var plat = platform_scene.instantiate()
		var x = randf_range(80, 640)
		var y = 1000 - (i + 1) * PLATFORM_SPACING
		plat.position = Vector2(x, y)
		add_child(plat)
		platforms.append(plat)

func _generate_platforms():
	var top_y = highest_y - 700
	var highest_platform_y = 99999.0
	for p in platforms:
		if is_instance_valid(p) and p.position.y < highest_platform_y:
			highest_platform_y = p.position.y

	while highest_platform_y > top_y:
		var plat = platform_scene.instantiate()
		var x = randf_range(80, 640)
		highest_platform_y -= PLATFORM_SPACING
		plat.position = Vector2(x, highest_platform_y)
		add_child(plat)
		platforms.append(plat)

func _cleanup_platforms():
	var bottom_limit = highest_y + 1000
	for i in range(platforms.size() - 1, -1, -1):
		var p = platforms[i]
		if is_instance_valid(p) and p.position.y > bottom_limit:
			p.queue_free()
			platforms.remove_at(i)

func _on_game_over():
	game_over = true
	game_over_label.visible = true
	player.set_physics_process(false)
