extends KinematicBody2D

const ACCELERATION: float = 2000.0
const MAX_SPEED: float = 500.0

var _motion: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	_direction = direction.normalized()


func _physics_process(delta: float) -> void:
	if _direction == Vector2.ZERO:
		apply_friction(delta)
	else:
		apply_movement(delta)

	_motion = move_and_slide(_motion)


func apply_friction (delta: float) -> void:
	var amount = ACCELERATION * delta
	if _motion.length() > amount:
		_motion -= _motion.normalized() * amount
	else:
		_motion = Vector2.ZERO


func apply_movement (delta: float) -> void:
	_motion += _direction * ACCELERATION * delta
	_motion = _motion.clamped(MAX_SPEED)
