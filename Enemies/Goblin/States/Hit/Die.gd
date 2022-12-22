extends GoblinState


func physics_process(delta: float) -> void:
	goblin.stop_moving(goblin.decceleration, delta)
	goblin.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	goblin.play_animation("Death")
	await get_tree().create_timer(2.0).timeout
	goblin.queue_free()
