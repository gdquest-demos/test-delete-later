extends PlayerState

@export var decceleration: float = 80


func physics_process(delta: float) -> void:
	if player.is_on_floor():
		player.stop_moving(player.fall_gravity, delta)
	else:
		player.stop_moving(decceleration, delta)
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	skin.play_animation("Hurt")
	skin.connect("animation_finished", _on_Skin_animation_finished)


func exit() -> void:
	skin.disconnect("animation_finished", _on_Skin_animation_finished)


func _on_Skin_animation_finished(anim_name: String) -> void:
	if anim_name == "Hurt":
		_state_machine.transition_to("Movement/Air")
