extends GoblinState


func physics_process(delta: float) -> void:
	goblin.stop_moving(goblin.decceleration, delta)
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	goblin.play_animation("Hurt")
	goblin.connect("animation_finished", _on_animation_finished)


func exit() -> void:
	goblin.disconnect("animation_finished", _on_animation_finished)


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Hurt":
		_state_machine.transition_to("Patrol/Idle")
