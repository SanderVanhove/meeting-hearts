extends KinematicBody2D
class_name Player

signal died
signal reset

const ACCELERATION: float = 3000.0
const MAX_SPEED: float = 1000.0

const hit_noises: Array = [
	preload("res://Things/Player/hit1.wav"),
	preload("res://Things/Player/hit2.wav"),
	preload("res://Things/Player/hit3.wav"),
]

var _goal: Goal

onready var _beat1: AudioStreamPlayer2D = $Audio/Beat1
onready var _beat2: AudioStreamPlayer2D = $Audio/Beat2
onready var _beat1_timer: Timer = $Audio/Beat1Timer
onready var _beat2_timer: Timer = $Audio/Beat2Timer
onready var _callout_timer: Timer = $Audio/CalloutTimer
onready var _tween: Tween = $Tween
onready var _visual: Node2D = $Visual
onready var _light: Light2D = $Light
onready var _joystick = $Joystick
onready var _arrow: Arrow = $Arrow
onready var _hit: AudioStreamPlayer = $Audio/Hit

var _motion: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO
var _dead: bool = false
var _hit_sound_index: int = 0


func _ready() -> void:
	_light.visible = true


func reset() -> void:
	_dead = false
	_beat1_timer.start()

	emit_signal("reset")


func set_goal(goal: Node2D) -> void:
	_goal = goal
	_arrow.goal = _goal


func _input(event: InputEvent) -> void:
	if _dead:
		_direction = Vector2.ZERO
		return

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

	if _joystick.visible:
		_direction = _joystick.output

	if event.is_action_pressed("call"):
		do_callout()


func do_callout() -> void:
	_beat1_timer.stop()
	_beat2_timer.stop()

	_beat1.volume_db = 0
	_beat2.volume_db = 0

	_beat1.play()
	spawn_noise_ring(300)

	_arrow.show_direction(true)

	_callout_timer.start()
	yield(_callout_timer, "timeout")

	_beat2.play()
	spawn_noise_ring(300)
	yield(_beat2, "finished")

	_arrow.show_direction(false)

	_goal.do_callout()

	_beat1_timer.start()
	_beat1.volume_db = -8
	_beat2.volume_db = -8


func _physics_process(delta: float) -> void:
	if _direction == Vector2.ZERO:
		apply_friction(delta)
	else:
		apply_movement(delta)

	_motion = move_and_slide(_motion)


func apply_friction(delta: float) -> void:
	var amount = ACCELERATION * delta
	if _motion.length() > amount:
		_motion -= _motion.normalized() * amount
	else:
		_motion = Vector2.ZERO


func apply_movement(delta: float) -> void:
	_motion += _direction * ACCELERATION * delta
	_motion = _motion.clamped(MAX_SPEED)


func spawn_noise_ring(radius: float = 200) -> void:
	var ring = Ring.new()
	add_child(ring)

	var time = .3
	_tween.interpolate_property(ring, "radius", 0, radius, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(ring, "opacity", 1, 0, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(ring, "width", 10, 0, time, Tween.TRANS_SINE, Tween.EASE_OUT)

	_tween.interpolate_property(_visual, "scale", _visual.scale, Vector2(.7, .7), .1)
	_tween.interpolate_property(_visual, "scale", Vector2(.7, .7), _visual.scale, .2, Tween.TRANS_SINE, Tween.EASE_OUT, .1)

	_tween.start()

	yield(_tween, "tween_all_completed")

	ring.queue_free()


func _on_Beat1Timer_timeout() -> void:
	_beat1.play()
	_beat2_timer.start()

	spawn_noise_ring()


func _on_Beat2Timer_timeout() -> void:
	_beat2.play()
	_beat1_timer.start()

	spawn_noise_ring()


func _on_Button_pressed() -> void:
	do_callout()


func _on_Area_area_entered(area: Area2D) -> void:
	if not area.is_in_group("enemy"):
		return

	_beat1_timer.stop()
	_beat2_timer.stop()

	_hit.stream = hit_noises[_hit_sound_index]
	_hit_sound_index = (_hit_sound_index + 1) % len(hit_noises)
	_hit.play()

	_motion = Vector2.ZERO

	_dead = true
	emit_signal("died")
