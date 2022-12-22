extends PlayerState


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if player.direction:
		skin.set_direction(player.direction)
		skin.play_animation("Run")
		
		collision_boxes.set_direction(player.direction)
	else:
		skin.play_animation("Idle")

	if not player.is_on_floor():
		_state_machine.transition_to("Movement/Air")
	elif Input.is_action_pressed("move_down") and Input.is_action_just_pressed("jump") and climb_detector.is_on_platform():
		_state_machine.transition_to("Movement/Air", { jumped_down = true })
	elif Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true })

	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)


func exit() -> void:
	_parent.exit()
