extends Resource
class_name GameplayEvents

signal weapon_detected(weapon_stats)
signal weapon_undetected

signal weapon_assigned(weapon_stats, slot)
signal weapon_dropped(weapon_stats)
