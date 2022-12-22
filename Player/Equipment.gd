extends Marker2D

@export var inventory: Inventory
@export var initial_weapon: WeaponStats
@export var movement_state_path: NodePath

var gameplay_events: GameplayEvents
var can_grab_weapon: bool = false

@onready var movement_state: PlayerState = get_node(movement_state_path)


func _unhandled_input(event: InputEvent) -> void:
	if can_grab_weapon:
		if event.is_action_pressed("add_primary_weapon"):
			equip_weapon(inventory.detected_weapon, 0)
		
		if event.is_action_pressed("add_secondary_weapon"):
			equip_weapon(inventory.detected_weapon, 1)


func _ready() -> void:
	await owner.ready
	
	gameplay_events = owner.gameplay_events
	gameplay_events.connect("weapon_detected", _on_GameplayEvents_weapon_detected)
	gameplay_events.connect("weapon_undetected", _on_GameplayEvents_weapon_undetected)
	
	equip_weapon(initial_weapon, 0)


func equip_weapon(weapon: WeaponStats, slot: int) -> void:
	var weapon_type: String = ""
	
	if weapon != null:
		match weapon.type: # To do: refactor with enums
			0:
				weapon_type = "melee"
			1:
				weapon_type = "ranged"
			2:
				weapon_type = "shield"

	match slot:
		0:
			gameplay_events.emit_signal("weapon_dropped", inventory.primary_weapon)
			movement_state.primary_action = weapon_type
			inventory.primary_weapon = weapon
		1:
			gameplay_events.emit_signal("weapon_dropped", inventory.secondary_weapon)
			movement_state.secondary_action = weapon_type
			inventory.secondary_weapon = weapon


func _on_GameplayEvents_weapon_detected(weapon: WeaponStats) -> void:
	inventory.detected_weapon = weapon
	can_grab_weapon = true


func _on_GameplayEvents_weapon_undetected() -> void:
	inventory.detected_weapon = null
	can_grab_weapon = false
