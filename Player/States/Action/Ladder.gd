extends PlayerState

@export var acceleration: float = 2000
@export var max_speed: float = 100


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Movement/Air", { jumped = true, velocity_x = max_speed * skin.get_facing_direction() })
		

func physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	player.move_y(acceleration, direction.y, max_speed, delta)
	skin.set_animation_speed(direction.length())
	
	
	if direction.x != 0:
		player.set_direction(sign(direction.x))
		skin.set_direction(sign(direction.x))


func enter(msg: Dictionary = {}) -> void:
	player.reset_speed()
	player.set_global_position(Vector2.RIGHT * msg.ladder_position.x - Vector2.UP * player.global_position.y) # To do (?): smooth out this transition
	
	skin.play_animation("LadderClimb")
	
	climb_detector.connect("ladder_exited", _on_ClimbDetector_ladder_exited)


func exit() -> void:
	climb_detector.disconnect("ladder_exited", _on_ClimbDetector_ladder_exited)


func _on_ClimbDetector_ladder_exited() -> void:
	_state_machine.transition_to("Movement/Air")
