extends PlayerState


func enter(_msg: Dictionary = {}) -> void:
	player.reset_speed()
	
	skin.play_animation("SlamHit")
	skin.connect("animation_finished", _on_Skin_animation_finished)
	

func exit() -> void:
	skin.disconnect("animation_finished", _on_Skin_animation_finished)


func _on_Skin_animation_finished(anim_name: String) -> void:
	if anim_name == "SlamHit":
		_state_machine.transition_to("Movement/Ground")
