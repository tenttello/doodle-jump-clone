extends Node

# Автозагрузка (Singleton)
# Project → Project Settings → Autoload → добавить этот скрипт как GameData

var coins: int = 0
var high_score: int = 0
var selected_skin: int = 0
var unlocked_skins: Array = [0]  # 0 всегда открыт

const SKINS = [
	{"name": "Синий", "color": Color(0.2, 0.7, 1.0), "price": 0},
	{"name": "Огонь", "color": Color(1.0, 0.35, 0.1), "price": 50},
	{"name": "Лайм", "color": Color(0.3, 0.95, 0.3), "price": 100},
	{"name": "Фиолет", "color": Color(0.7, 0.3, 1.0), "price": 150},
	{"name": "Золото", "color": Color(1.0, 0.85, 0.2), "price": 300},
	{"name": "Тёмный", "color": Color(0.15, 0.15, 0.2), "price": 200},
]

func _ready():
	load_data()

func save_data():
	var f = FileAccess.open("user://save.dat", FileAccess.WRITE)
	if f:
		f.store_var({
			"coins": coins,
			"high_score": high_score,
			"selected_skin": selected_skin,
			"unlocked_skins": unlocked_skins,
		})

func load_data():
	if FileAccess.file_exists("user://save.dat"):
		var f = FileAccess.open("user://save.dat", FileAccess.READ)
		if f:
			var d = f.get_var()
			if typeof(d) == TYPE_DICTIONARY:
				coins = d.get("coins", 0)
				high_score = d.get("high_score", 0)
				selected_skin = d.get("selected_skin", 0)
				unlocked_skins = d.get("unlocked_skins", [0])

func add_coins(amount: int):
	coins += amount
	save_data()

func unlock_skin(index: int) -> bool:
	if index in unlocked_skins:
		return true
	var price = SKINS[index]["price"]
	if coins >= price:
		coins -= price
		unlocked_skins.append(index)
		save_data()
		return true
	return false

func select_skin(index: int):
	if index in unlocked_skins:
		selected_skin = index
		save_data()
		return true
	return false
