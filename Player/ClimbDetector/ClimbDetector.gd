extends Marker2D
class_name ClimbDetector

signal ladder_detected(pos)
signal ladder_exited

@onready var _platform_detector: RayCast2D = $PlatformDetector
@onready var _ray_top: RayCast2D = $RayTop
@onready var _ray_bottom: RayCast2D = $RayBottom
@onready var _floor_detector: RayCast2D = $FloorDetector
@onready var _ladder_detector: Area2D = $LadderDetector


func _ready() -> void:
	_ladder_detector.connect("body_entered", _on_LadderDetector_body_entered)
	_ladder_detector.connect("body_exited", _on_LadderDetector_body_exited)


func activate() -> void:
	_platform_detector.enabled = true
	_ray_top.enabled = true
	_ray_bottom.enabled = true
	# The floor detector will be always active


func deactivate() -> void:
	_platform_detector.enabled = false
	_ray_top.enabled = false
	_ray_bottom.enabled = false


func get_direction() -> float:
	return sign(scale.x)


func is_against_ledge() -> bool:
	return _ray_bottom.is_colliding() and not _ray_top.is_colliding()


func get_ledge_target_position() -> Vector2:
	return _ray_top.global_position + _ray_top.target_position * sign(scale.x)


func get_platform_target_position() -> Vector2:
	var platform: StaticBody2D = _platform_detector.get_collider()
	var target_position_x: float = _platform_detector.get_collision_point().x - platform.global_position.x
	return target_position_x * Vector2.RIGHT + _platform_detector.get_collider().global_position 


func is_under_platform() -> bool:
	return _platform_detector.is_colliding()


func is_on_platform() -> bool:
	return _floor_detector.is_colliding()


func get_floor_position() -> Vector2:
	_floor_detector.force_raycast_update()
	return _floor_detector.get_collision_point()


func _on_LadderDetector_body_entered(body: PhysicsBody2D) -> void:
	emit_signal("ladder_detected", body.global_position)


func _on_LadderDetector_body_exited(_body: PhysicsBody2D) -> void:
	emit_signal("ladder_exited")
