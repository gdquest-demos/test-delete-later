extends PlayerState

@export var speed: float = 400
@export var decceleration: float = 600

var _was_on_floor: bool = true

@onready var _timer: Timer = $Timer


func physics_process(delta: float) -> void:
	player.stop_moving(decceleration, delta)
	
	if not player.is_on_floor():
		player.apply_gravity(delta)
	
	if not player.is_on_floor() and _was_on_floor:
		_state_machine.transition_to("Movement/Air", { from_dodging = true })
		
	var direction: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if direction != 0 and _timer.time_left != 0:
		player.set_velocity(Vector2.RIGHT * abs(player.velocity.x) * direction - Vector2.UP * player.velocity.y)
		player.set_direction(direction)
		skin.set_direction(direction)
		
		_timer.stop()


func enter(_msg: Dictionary = {}) -> void:
	player.set_velocity(Vector2.RIGHT * speed * skin.get_facing_direction() - Vector2.UP * abs(player.velocity.y))
	player.disable_hurt_box()
	
	skin.play_animation("Dodge", 2)
	skin.connect("animation_finished", _on_Skin_animation_finished)
	
	_was_on_floor = player.is_on_floor()
	_timer.start()


func exit() -> void:
	player.enable_hurt_box()
	skin.disconnect("animation_finished", _on_Skin_animation_finished)

	_timer.stop()


func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Movement/Ground")
