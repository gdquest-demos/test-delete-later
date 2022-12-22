extends PlayerState

var _action: String = ""


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(_action):
		_state_machine.transition_to("Movement/Ground")


func physics_process(delta: float) -> void:
	player.stop_moving(player.decceleration, delta)
	player.apply_gravity(delta)


func enter(msg: Dictionary = {}) -> void:
	player.enable_block_box()
	skin.play_animation("BlockIdle")

	_action = msg.action


func exit() -> void:
	player.disable_block_box()
