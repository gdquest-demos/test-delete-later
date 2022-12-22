extends GoblinState

@export var player_min_distance: float = 60
@onready var _timer: Timer = $Timer
@onready var _direction_timer: Timer = $DirectionTimer


func _ready() -> void:
	super._ready()
	_timer.connect("timeout", _on_Timer_timeout)
	_direction_timer.connect("timeout", _on_DirectionTimer_timeout)
	

func physics_process(delta: float) -> void:
	goblin.stop_moving(goblin.decceleration, delta)


func enter(_msg: Dictionary = {}) -> void:
	goblin.set_direction(sign(goblin.global_position.direction_to(player.global_position).x))
	goblin.play_animation("Idle")
	
	_timer.start()
	_direction_timer.start()


func exit() -> void:
	_timer.stop()
	_direction_timer.stop()


func _on_Timer_timeout() -> void:
	if goblin.global_position.distance_to(player.global_position) > player_min_distance:
		_state_machine.transition_to("Attack/Jump")
	else:
		_state_machine.transition_to("Attack/Melee")


func _on_DirectionTimer_timeout() -> void:
	goblin.set_direction(sign(goblin.global_position.direction_to(player.global_position).x))
