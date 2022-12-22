extends Area2D
class_name HurtBox

signal damage_dealt(amount, force)

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _timer: Timer = $Timer


func _ready() -> void:
	connect("area_entered", _on_area_entered)
	_timer.connect("timeout", _on_Timer_timeout)


func set_enabled(value: bool) -> void:
	_collision_shape.set_deferred("disabled", not value)
	

func _on_area_entered(hit_box: HitBox) -> void:
	var direction: Vector2 = hit_box.global_position.direction_to(global_position)
	emit_signal("damage_dealt", hit_box.damage, hit_box.force * direction)
	
	_collision_shape.set_deferred("disabled", true)
	_timer.start()


func _on_Timer_timeout() -> void:
	_collision_shape.set_deferred("disabled", false)
