extends GoblinState

@export var attack_speed: float = 250.0
@export var decceleration: float = 50.0


func physics_process(delta: float) -> void:
	goblin.stop_moving(decceleration, delta)


func enter(_msg: Dictionary = {}) -> void:
	goblin.play_animation("JumpAttack")
	goblin.connect("animation_finished", _on_animation_finished)
	goblin.connect("attack_started", _on_attack_started)


func exit() -> void:
	goblin.disconnect("animation_finished", _on_animation_finished)
	goblin.disconnect("attack_started", _on_attack_started)
	
	_on_attack_ended()


func _on_attack_started() -> void:
	goblin.set_velocity(Vector2.RIGHT * goblin.direction * attack_speed + Vector2.UP * goblin.jump_speed)
	goblin.enable_hit_box()


func _on_attack_ended() -> void:
	goblin.disable_hit_box()


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "JumpAttack":
		_state_machine.transition_to("Patrol/Idle")
