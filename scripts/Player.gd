extends CharacterBody2D

const SPEED = 380.0
const JUMP_VELOCITY = -780.0
const GRAVITY = 1900.0

var touch_x: float = -1.0

func _ready():
	_apply_skin()

func _apply_skin():
	var skin = GameData.SKINS[GameData.selected_skin]
	$ColorRect.color = skin["color"]

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_x = event.position.x
		else:
			touch_x = -1.0
	elif event is InputEventScreenDrag:
		touch_x = event.position.x

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = 0.0

	# Клавиатура (для теста на ПК)
	direction = Input.get_axis("move_left", "move_right")

	# Тач: палец левее/правее центра экрана
	if touch_x >= 0.0:
		var center = get_viewport_rect().size.x / 2.0
		if touch_x < center - 20:
			direction = -1.0
		elif touch_x > center + 20:
			direction = 1.0
		else:
			direction = 0.0

	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 1.5)

	move_and_slide()

	if is_on_floor() and velocity.y >= 0:
		velocity.y = JUMP_VELOCITY

	# Зацикливание по горизонтали
	if position.x < -40:
		position.x = 760
	elif position.x > 760:
		position.x = -40
