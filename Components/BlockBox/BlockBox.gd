extends Area2D
class_name BlockBox

signal blocked(damage, force)

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	connect("area_entered", _on_area_entered)


func set_enabled(value: bool) -> void:
	_collision_shape.set_deferred("disabled", not value)


func _on_area_entered(hit_box: HitBox) -> void:
	var direction: Vector2 = hit_box.global_position.direction_to(global_position)
	emit_signal("blocked", hit_box.damage, hit_box.force * direction)
