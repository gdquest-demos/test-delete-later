extends GoblinState

@export var attack_speed: float = 80.0


func physics_process(delta: float) -> void:
	goblin.stop_moving(goblin.decceleration, delta)


func enter(_msg: Dictionary = {}) -> void:
	goblin.play_animation("MeleeAttack")
	
	goblin.connect("animation_finished", _on_animation_finished)
	goblin.connect("attack_started", _on_attack_started)
	goblin.connect("attack_ended", _on_attack_ended)


func exit() -> void:
	goblin.disconnect("animation_finished", _on_animation_finished)
	goblin.disconnect("attack_started", _on_attack_started)
	goblin.disconnect("attack_ended", _on_attack_ended)
	
	_on_attack_ended()


func _on_attack_started() -> void:
	goblin.set_velocity(Vector2.RIGHT * goblin.direction * attack_speed - Vector2.UP * goblin.velocity)
	goblin.enable_hit_box()


func _on_attack_ended() -> void:
	goblin.disable_hit_box()


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "MeleeAttack":
		_state_machine.transition_to("Patrol/Idle")
