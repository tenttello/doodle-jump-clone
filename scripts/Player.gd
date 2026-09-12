extends CharacterBody2D

const SPEED = 320.0
const JUMP_VELOCITY = -750.0
const GRAVITY = 1800.0

func _physics_process(delta):
	# Гравитация
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Движение влево-вправо
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Прыжок только когда падаем на платформу
	move_and_slide()

	if is_on_floor() and velocity.y >= 0:
		velocity.y = JUMP_VELOCITY

	# Экран зациклен по горизонтали
	if position.x < -30:
		position.x = 750
	elif position.x > 750:
		position.x = -30
