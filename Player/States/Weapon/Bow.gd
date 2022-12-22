extends PlayerState

@export var arrow_scene: PackedScene


func physics_process(delta: float) -> void:
	player.apply_gravity(delta)


func enter(_msg: Dictionary = {}) -> void:
	player.reset_speed()
	
	skin.play_animation("Shoot")
	skin.connect("attack_started", _on_Skin_attack_started)
	skin.connect("animation_finished", _on_Skin_animation_finished)


func exit() -> void:
	skin.disconnect("attack_started", _on_Skin_attack_started)
	skin.disconnect("animation_finished", _on_Skin_animation_finished)


func shoot_arrow(_position: Vector2, direction: int) -> void:
	var arrow: Node2D = arrow_scene.instantiate()
	get_tree().get_root().add_child(arrow)
	arrow.set_global_position(projectile_spawner.global_position)
	arrow.set_direction(direction)


func _on_Skin_attack_started() -> void:
	shoot_arrow(player.global_position, skin.get_facing_direction())


func _on_Skin_animation_finished(anim_name: String) -> void:
	if anim_name == "Shoot":
		_state_machine.transition_to("Movement/Air")


func _on_Timer_timeout() -> void:
	skin.play_animation("Shoot")
