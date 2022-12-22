extends PlayerState

@export var slide_speed: float = 500
@export var decceleration: float = 10000


func physics_process(delta: float) -> void:
	player.stop_moving(decceleration, delta)
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	var direction: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	player.set_direction(direction)
	
	skin.set_direction(direction)
	skin.connect("attack_started", _on_attack_started)
	skin.connect("attack_ended", _on_attack_ended)


func exit() -> void:
	skin.disconnect("attack_started", _on_attack_started)
	skin.disconnect("attack_ended", _on_attack_ended)
	
	_on_attack_ended()


func _on_attack_started() -> void:
	player.set_velocity(Vector2.RIGHT * slide_speed * skin.get_facing_direction() - Vector2.UP * abs(player.velocity.y))
	hit_box.enable()


func _on_attack_ended() -> void:
	hit_box.disable()
