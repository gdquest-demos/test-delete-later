extends CharacterBody2D
class_name Player

@export var main_instances: MainInstances
@export var gameplay_events: GameplayEvents
@export var stats: PlayerStats
@export var skin_path: NodePath

@export var acceleration: float = 1500
@export var decceleration: float = 1500
@export var max_gravity: float = 500

@export var jump_distance: float = 80
@export var jump_height: float = 40
@export var jump_time_to_peak: float = 0.27
@export var jump_time_to_descent: float = 0.32
@export var jump_cut_value: float = 14

var direction: float = 0 : set = set_direction

@onready var skin: PlayerSkin = get_node(skin_path)
@onready var climb_detector: ClimbDetector = $ClimbDetector

@onready var max_speed: float = jump_distance / (jump_time_to_peak + jump_time_to_descent)
@onready var jump_speed: float = (-2 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = (2 * jump_height) / pow(jump_time_to_peak, 2)
@onready var fall_gravity: float = (2 * jump_height) / pow(jump_time_to_descent, 2)
@onready var jump_cut_speed: float = fall_gravity / jump_cut_value

@onready var collision_boxes: Marker2D = $CollisionBoxes
@onready var hit_box: HitBox = $CollisionBoxes/HitBox
@onready var projectile_spawner: Marker2D = $CollisionBoxes/ProjectileSpawner
@onready var _hurt_box: HurtBox = $CollisionBoxes/HurtBox
@onready var _block_box: BlockBox = $CollisionBoxes/BlockBox

@onready var _state_machine: StateMachine = $StateMachine

func _ready() -> void:
	main_instances.player = self
	
	stats.health = stats.max_health # Temporary

	_hurt_box.connect("damage_dealt", _on_HurtBox_damage_dealt)
	_block_box.connect("blocked", _on_BlockBox_blocked)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(value: float) -> void:
	direction = value
	
	if direction != 0:
		climb_detector.scale.x = sign(value)


func reset_y_speed() -> void:
	velocity.y = 0


func reset_speed() -> void:
	velocity.x = 0
	velocity.y = 0


func jump(curr_jump_speed: float, curr_reset_y_speed: bool = false) -> void:
	if curr_reset_y_speed:
		reset_y_speed()
	velocity.y = -curr_jump_speed


func move(curr_acceleration: float, curr_direction: float, curr_max_speed: float, delta: float) -> void:
	velocity.x += curr_acceleration * curr_direction * delta
	velocity.x = clamp(velocity.x, -curr_max_speed, curr_max_speed)


func move_y(curr_acceleration: float, curr_direction: float, curr_max_speed: float, delta: float) -> void:
	if curr_direction != 0:
		velocity.y += curr_acceleration * curr_direction * delta
	else:
		velocity.y = move_toward(velocity.y, 0, curr_acceleration * delta)
	velocity.y = clamp(velocity.y, -curr_max_speed, curr_max_speed)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y += fall_gravity * delta
		else:
			velocity.y += jump_gravity * delta
		velocity.y = min(velocity.y, max_gravity)


func stop_moving(curr_decceleration: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, curr_decceleration * delta)


func get_damage(amount: float, force: Vector2) -> void: # Have this method separated for projectiles
	if _state_machine.state_name == "Damage" or _state_machine.state_name == "Die" or _state_machine.state_name == "Block":
		return
		
	stats.health -= amount
	set_velocity(force)
	
	if stats.health > 0:
		_state_machine.transition_to("Hit/Damage")
	else:
		_state_machine.transition_to("Hit/Die")


func block(_damage: float, force: Vector2) -> void: # Have this method separated for projectiles
#	stats.health -= damage # To do: Subtract amount from shield
	set_velocity(Vector2.RIGHT * force.x) # To do: Subtract force with resistance
	
	_state_machine.transition_to("Hit/Block")


func enable_hurt_box() -> void:
	_hurt_box.set_enabled(true)
	

func disable_hurt_box() -> void:
	_hurt_box.set_enabled(false)


func enable_block_box() -> void:
	_block_box.set_enabled(true)


func disable_block_box() -> void:
	_block_box.set_enabled(false)


func _on_HurtBox_damage_dealt(amount: float, force: Vector2) -> void:
	get_damage(amount, force)


func _on_BlockBox_blocked(damage: float, force: Vector2) -> void:
	block(damage, force)


func _on_LadderDetector_body_entered(_body: PhysicsBody2D) -> void:
	if _state_machine.state_name == "Damage" or _state_machine.state_name == "Die" or _state_machine.state_name == "Block":
		return
	
	_state_machine.transition_to("Movement/Ladder")
