extends PlayerState

var _action: String = ""
@onready var _timer: Timer = $Timer


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_action) and _timer.time_left == 0:
		_state_machine.transition_to("Weapon/Sword/Combo3")


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	skin.play_animation("SwordCombo2")
	skin.connect("animation_finished", _on_Skin_animation_finished)
	
	_action = msg.action
	_timer.start()


func exit() -> void:
	_parent.exit()
	
	skin.disconnect("animation_finished", _on_Skin_animation_finished)
	
	_timer.stop()


func _on_Skin_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to("Movement/Ground") 
