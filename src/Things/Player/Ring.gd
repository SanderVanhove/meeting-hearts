extends Node2D
class_name Ring


const TWO_PI: float = PI * 2


export var radius: float = 10
export var opacity: float = 1
export var width: float = 2

var _color: Color = Color("84009C")
var _collision_shape: CircleShape2D = CircleShape2D.new()


func _ready() -> void:
	var area: Area2D = Area2D.new()
	var col_shape: CollisionShape2D = CollisionShape2D.new()
	col_shape.shape = _collision_shape
	area.add_child(col_shape)
	area.add_to_group("heartbeat_ring")
	add_child(area)


func _process(delta: float) -> void:
	update()
	_collision_shape.radius = radius


func _draw() -> void:
	_color.a = opacity
	draw_arc(Vector2.ZERO, radius, 0, TWO_PI, 20, _color, width, true)
