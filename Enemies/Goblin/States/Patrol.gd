extends GoblinState

@export var player_min_distance: float = 80.0


func physics_process(_delta: float) -> void:
	if goblin.player_detected() or goblin.global_position.distance_to(player.global_position) < player_min_distance:
		_state_machine.transition_to("Attack")


func enter(_msg: Dictionary = {}) -> void:
	goblin.enable_detections()
	

func exit() -> void:
	goblin.disable_detections()
