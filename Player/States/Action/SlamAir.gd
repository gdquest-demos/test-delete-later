extends PlayerState

@export var acceleration: float = 2000
@export var max_speed: float = 1200


func physics_process(delta: float) -> void:
	player.move_y(acceleration, 1, max_speed, delta)
	
	if player.is_on_floor():
		_state_machine.transition_to("Action/SlamHit")


func enter(_msg: Dictionary = {}) -> void:
	player.reset_speed()
	player.jump(player.jump_speed)
	
	skin.play_animation("SlamIdle")
