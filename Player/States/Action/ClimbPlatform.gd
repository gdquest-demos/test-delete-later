extends PlayerState

@export var decceleration: float = 2000


func physics_process(delta: float) -> void:
	player.stop_moving(decceleration, delta)
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	var start_position: Vector2 = player.global_position
	
	player.reset_speed()
	player.set_global_position(climb_detector.get_platform_target_position())
#	player.set_global_position(climb_detector.get_floor_position())

	skin.connect("animation_finished", _on_Skin_animation_finished)
	skin.play_animation("Climb", 1, start_position - player.global_position)


func exit() -> void:
	skin.disconnect("animation_finished", _on_Skin_animation_finished)


func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Movement/Ground")
