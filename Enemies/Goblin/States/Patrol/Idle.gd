extends GoblinState

@export var time_intervals: Vector2 = Vector2(0.8, 1.4)
@onready var _timer: Timer = $Timer


func _ready() -> void:
	super._ready()
	_timer.connect("timeout", _on_Timer_timeout)


func physics_process(delta: float) -> void:
	goblin.stop_moving(goblin.decceleration, delta)
	
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	goblin.play_animation("Idle")
	_timer.start(randf_range(time_intervals.x, time_intervals.y))


func exit() -> void:
	_parent.exit()
	_timer.stop()


func _on_Timer_timeout() -> void:
	_state_machine.transition_to("Patrol/Walk")
