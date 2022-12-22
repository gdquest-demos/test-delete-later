extends Resource
class_name PlayerStats

signal max_health_changed(amount)
signal health_changed(amount)

var max_health: float = 5 : set = set_max_health
var health: float = max_health : set = set_health


func set_max_health(value: float) -> void:
	max_health = value
	emit_signal("max_health_changed", max_health)


func set_health(value: float) -> void:
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
