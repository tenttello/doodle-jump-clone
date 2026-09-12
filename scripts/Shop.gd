extends Control

@onready var coins_label = $CoinsLabel
@onready var list = $Scroll/List

func _ready():
	_refresh()

func _refresh():
	coins_label.text = "Монеты: " + str(GameData.coins)
	for c in list.get_children():
		c.queue_free()

	for i in range(GameData.SKINS.size()):
		var skin = GameData.SKINS[i]
		var row = HBoxContainer.new()
		row.custom_minimum_size = Vector2(0, 70)

		var color_rect = ColorRect.new()
		color_rect.custom_minimum_size = Vector2(50, 50)
		color_rect.color = skin["color"]
		row.add_child(color_rect)

		var name_l = Label.new()
		name_l.text = "  " + skin["name"]
		name_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(name_l)

		var btn = Button.new()
		btn.custom_minimum_size = Vector2(140, 50)

		if i in GameData.unlocked_skins:
			if GameData.selected_skin == i:
				btn.text = "Выбран"
				btn.disabled = true
			else:
				btn.text = "Выбрать"
				btn.pressed.connect(_on_select.bind(i))
		else:
			btn.text = str(skin["price"]) + " монет"
			btn.pressed.connect(_on_buy.bind(i))

		row.add_child(btn)
		list.add_child(row)

func _on_buy(index: int):
	if GameData.unlock_skin(index):
		GameData.select_skin(index)
		_refresh()
	else:
		var d = AcceptDialog.new()
		d.dialog_text = "Не хватает монет"
		add_child(d)
		d.popup_centered()

func _on_select(index: int):
	GameData.select_skin(index)
	_refresh()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
