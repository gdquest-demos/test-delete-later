extends PlayerState


func physics_process(delta: float) -> void:
	player.stop_moving(player.decceleration, delta)
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	skin.play_animation("Death")
