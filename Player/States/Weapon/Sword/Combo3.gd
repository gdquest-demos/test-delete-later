extends PlayerState


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	skin.play_animation("SwordCombo3")
	skin.connect("animation_finished", _on_Skin_animation_finished)


func exit() -> void:
	_parent.exit()
	
	skin.disconnect("animation_finished", _on_Skin_animation_finished)


func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Movement/Ground") 
