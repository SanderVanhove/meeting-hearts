extends KinematicBody2D

const ACCELERATION: float = 2000.0
const MAX_SPEED: float = 1000.0

onready var _beat1: AudioStreamPlayer2D = $Audio/Beat1
onready var _beat2: AudioStreamPlayer2D = $Audio/Beat2
onready var _beat1_timer: Timer = $Audio/Beat1Timer
onready var _beat2_timer: Timer = $Audio/Beat2Timer

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


func _on_Beat1Timer_timeout() -> void:
	_beat1.play()
	_beat2_timer.start()


func _on_Beat2Timer_timeout() -> void:
	_beat2.play()
	_beat1_timer.start()
