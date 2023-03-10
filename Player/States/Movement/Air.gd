extends PlayerState

var _can_double_jump: bool = true
var _jump_released: bool = false

@onready var _coyote_timer: Timer =$CoyoteTimer


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if _coyote_timer.time_left > 0:
			_state_machine.transition_to("Movement/Air", { jumped = true })
		elif _can_double_jump:
			_can_double_jump = false
			_state_machine.transition_to("Movement/Air", { jumped = true })

	
	if event.is_action_released("jump"):
		if player.velocity.y < 0 and player.velocity.y < -player.jump_cut_speed and not _jump_released:
			player.jump(-player.jump_cut_speed)
			_jump_released = true
	
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if player.is_on_ceiling():
		player.reset_y_speed()

	if player.is_on_floor():
		_can_double_jump = true
		_state_machine.transition_to("Movement/Ground")
	elif climb_detector.is_against_ledge():
		_state_machine.transition_to("Action/LedgeGrab")
	elif climb_detector.is_under_platform() and player.velocity.y < 0:
		_state_machine.transition_to("Action/ClimbPlatform")
	
	if Input.is_action_pressed("move_down") and Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Action/SlamAir")
	
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	if "jumped" in msg:
		if "velocity_x" in msg:
			player.reset_speed()
			player.set_velocity(Vector2.UP * player.velocity.y + Vector2.RIGHT * msg.velocity_x)
		player.jump(-player.jump_speed)
		
		skin.play_animation("Jump")
		skin.connect("animation_finished", _on_Skin_animation_finished)
	elif "jumped_down" in msg:
		player.set_collision_mask_value(3, false)
		
		skin.play_animation("JumpDown")
		skin.connect("animation_finished", _on_Skin_animation_finished)
	else:
		skin.play_animation("Fall")
		
		_coyote_timer.start()

	if "from_dodging" in msg:
		player.set_velocity(Vector2.UP * player.velocity.y + Vector2.RIGHT * skin.get_facing_direction() * player.max_speed)
	
	climb_detector.activate()


func exit() -> void:
	_parent.exit()
	
	if skin.is_connected("animation_finished", _on_Skin_animation_finished):
		skin.disconnect("animation_finished", _on_Skin_animation_finished)

	climb_detector.deactivate()

	_jump_released = false
	_coyote_timer.stop()


func _on_Skin_animation_finished(anim_name: String) -> void:
	if anim_name == "JumpDown":
		player.set_collision_mask_value(3, true)
	
	skin.play_animation("Fall")
