extends CharacterBody2D
class_name Goblin

signal attack_started
signal attack_ended
signal animation_finished(anim_name)

@export var health: int = 3 
@export var main_instances: MainInstances

@export var jump_speed: float = 220.0
@export var move_speed: float = 50.0
@export var acceleration: float = 500.0
@export var decceleration: float = 500.0

var direction: float = 1 : set = set_direction
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _detectors: Marker2D = $Detectors
@onready var _player_detector: RayCast2D = $Detectors/PlayerDetector
@onready var _wall_detector: RayCast2D = $Detectors/WallDetector
@onready var _ledge_detector: RayCast2D = $Detectors/LedgeDetector

@onready var _collision_boxes: Marker2D = $CollisionBoxes
@onready var _hit_box: HitBox = $CollisionBoxes/HitBox
@onready var _hurt_box: HurtBox = $CollisionBoxes/HurtBox

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _state_machine: StateMachine = $StateMachine


func _ready() -> void:
	_animation_player.connect("animation_finished", _on_AnimationPlayer_animation_finished)
	_hurt_box.connect("damage_dealt", get_damage)
	
	if randf() > 0.5:
		set_direction(-1)


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()


func set_direction(value: float) -> void:
	direction = sign(value)

	_detectors.scale.x = direction
	_collision_boxes.scale.x = direction
	_animated_sprite.flip_h = direction != 1


func jump(curr_jump_speed: float) -> void:
	velocity.y = -curr_jump_speed


func move(curr_acceleration: float, curr_direction: float, curr_max_speed: float, delta: float) -> void:
	velocity.x += curr_acceleration * curr_direction * delta
	velocity.x = clamp(velocity.x, -curr_max_speed, curr_max_speed)


func stop_moving(curr_decceleration: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, curr_decceleration * delta)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, gravity)


func player_detected() -> bool:
	return _player_detector.is_colliding()


func wall_detected() -> bool:
	return _wall_detector.is_colliding()
	

func ledge_detected() -> bool:
	return not _ledge_detector.is_colliding()


func enable_detections() -> void:
	_player_detector.enabled = true


func disable_detections() -> void:
	_player_detector.enabled = false


func play_animation(anim_name: String) -> void:
	_animation_player.play(anim_name)


func enable_hit_box() -> void:
	_hit_box.enable()
	

func disable_hit_box() -> void:
	_hit_box.disable()


func get_damage(amount: float, force: Vector2) -> void: # Have this method separated for projectiles
	if _state_machine.state_name == "Damage" or _state_machine.state_name == "Die":
		return
		
	health -= int(amount)
	set_velocity(force)
	
	if health > 0:
		_state_machine.transition_to("Hit/Damage")
	else:
		_state_machine.transition_to("Hit/Die")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
