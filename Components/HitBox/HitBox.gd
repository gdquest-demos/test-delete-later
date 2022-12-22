extends Area2D
class_name HitBox

@export var damage: float = 1
@export var force: float = 200

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func enable() -> void:
	collision_shape.set_deferred("disabled", false)


func disable() -> void:
	collision_shape.set_deferred("disabled", true)
