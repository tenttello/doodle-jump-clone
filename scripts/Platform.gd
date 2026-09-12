extends StaticBody2D

@export var platform_type: String = "normal"  # normal, moving, breakable

var move_dir: float = 1.0
var move_speed: float = 80.0
var start_x: float = 0.0

func _ready():
	start_x = position.x
	match platform_type:
		"moving":
			$ColorRect.color = Color(0.2, 0.6, 1.0)
			move_speed = randf_range(60, 120)
		"breakable":
			$ColorRect.color = Color(0.9, 0.4, 0.3)
		_:
			$ColorRect.color = Color(0.3, 0.85, 0.4)

func _physics_process(delta):
	if platform_type == "moving":
		position.x += move_dir * move_speed * delta
		if position.x > start_x + 120 or position.x < start_x - 120:
			move_dir *= -1.0
