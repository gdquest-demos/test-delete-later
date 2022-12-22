extends Resource
class_name Inventory

signal primary_weapon_changed(weapon_stats)
signal secondary_weapon_changed(weapon_stats)

var detected_weapon: WeaponStats
var primary_weapon: WeaponStats : set = set_primary_weapon
var secondary_weapon: WeaponStats : set = set_secondary_weapon


func set_primary_weapon(value: WeaponStats) -> void:
	primary_weapon = value
	emit_signal("primary_weapon_changed", value)


func set_secondary_weapon(value: WeaponStats) -> void:
	secondary_weapon = value
	emit_signal("secondary_weapon_changed", value)
