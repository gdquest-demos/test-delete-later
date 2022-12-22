extends AnimatableBody2D

@export var damage: float = 1
@export var force: float = 200
@export var destroy_on_touch: bool = true
@export var speed: float = 250

var _direction: int = 1 : set = set_direction

@onready var _sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(Vector2.RIGHT * _direction * speed * delta)
	
	if collision:
		if collision.get_collider():
			var collider = collision.get_collider()
			if collider.has_method("get_damage"):
				var direction: Vector2 = global_position.direction_to(collider.global_position)
				direction.y *= -1
				collider.get_damage(damage, direction * force)
		
		if destroy_on_touch:
			queue_free()


func set_direction(value: int) -> void:
	_direction = value
	if _direction != 0:
		_sprite.scale.x = abs(_sprite.scale.x) * sign(_direction)
		_sprite.scale.y = abs(_sprite.scale.y) * sign(_direction) # Remove line when using final asset
