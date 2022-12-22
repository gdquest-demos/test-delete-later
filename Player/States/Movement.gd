extends PlayerState

# "melee", "ranged" or "shield"
var primary_action: String = ""
var secondary_action: String = ""


func set_action_to_state(action_button: String, action_name: String) -> void: # To do: rename this function
	match action_name:
		"melee":
			_state_machine.transition_to("Weapon/Sword/Combo1", { action = action_button })
		"ranged":
			_state_machine.transition_to("Weapon/Bow", { action = action_button })
		_:
			return


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		_state_machine.transition_to("Action/Dodge")
		
	if event.is_action_pressed("primary_weapon"):
		set_action_to_state("primary_weapon", primary_action)
		
	if event.is_action_pressed("secondary_weapon"):
		set_action_to_state("secondary_weapon", secondary_action)


func physics_process(delta: float) -> void:
	player.set_direction(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	if player.direction != 0:
		player.move(player.acceleration, player.direction, player.max_speed, delta)
	
	if player.is_on_floor() and player.direction == 0:
		player.stop_moving(player.decceleration, delta)
	
	
	if Input.is_action_pressed("primary_weapon") and primary_action == "shield":
		_state_machine.transition_to("Weapon/Shield", { action = "primary_weapon" })
	
	if Input.is_action_pressed("secondary_weapon") and secondary_action == "shield":
		_state_machine.transition_to("Weapon/Shield", { action = "secondary_weapon" })
	
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	climb_detector.connect("ladder_detected", _on_ClimbDetector_ladder_detected)


func exit() -> void:
	climb_detector.disconnect("ladder_detected", _on_ClimbDetector_ladder_detected)


func _on_ClimbDetector_ladder_detected(pos: Vector2) -> void:
	_state_machine.transition_to("Movement/Ladder", { ladder_position = pos })
