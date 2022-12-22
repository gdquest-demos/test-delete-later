extends Panel

@export var inventory: Inventory
@export var player_stats: PlayerStats

@onready var primary_weapon_texture_rect: TextureRect = $VBoxContainer/EquipmentContainer/PrimaryWeapon/TextureRect
@onready var secondary_weapon_texture_rect: TextureRect = $VBoxContainer/EquipmentContainer/SecondaryWeapon/TextureRect

@onready var health_bar: ProgressBar = $VBoxContainer/HealthContainer/ProgressBar


func _ready() -> void:
	inventory.connect("primary_weapon_changed", _on_Inventory_primary_weapon_changed)
	inventory.connect("secondary_weapon_changed", _on_Inventory_secondary_weapon_changed)
	
	player_stats.connect("health_changed", _on_PlayerStats_health_changed)
	
	_on_Inventory_primary_weapon_changed(inventory.primary_weapon)
	health_bar.max_value = player_stats.max_health
	health_bar.value = player_stats.health


func _on_Inventory_primary_weapon_changed(stats: WeaponStats) -> void:
	if stats == null:
		primary_weapon_texture_rect.texture = null
	else:
		primary_weapon_texture_rect.texture = stats.texture


func _on_Inventory_secondary_weapon_changed(stats: WeaponStats) -> void:
	if stats == null:
		secondary_weapon_texture_rect.texture = null
	else:
		secondary_weapon_texture_rect.texture = stats.texture


func _on_PlayerStats_health_changed(health: float) -> void:
	health_bar.value = health
