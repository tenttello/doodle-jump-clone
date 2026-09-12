extends Control

@onready var coins_label = $CoinsLabel
@onready var high_score_label = $HighScoreLabel

func _ready():
	coins_label.text = "Монеты: " + str(GameData.coins)
	high_score_label.text = "Рекорд: " + str(GameData.high_score)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_shop_pressed():
	get_tree().change_scene_to_file("res://scenes/Shop.tscn")

func _on_donate_pressed():
	# Заглушка под реальный донат / IAP
	# Здесь позже подключается Google Play Billing / App Store
	var dialog = AcceptDialog.new()
	dialog.dialog_text = "Донат (реальные покупки)\n\nЧтобы включить настоящие платежи:\n1. Создай аккаунт Google Play Console\n2. Добавь in-app products\n3. Подключи плагин биллинга в Godot\n\nСейчас магазин работает за монеты."
	add_child(dialog)
	dialog.popup_centered()
