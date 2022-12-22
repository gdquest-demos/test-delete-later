extends Area2D
class_name Weapon

@export var gameplay_events: GameplayEvents
@export var stats: WeaponStats

@onready var _sprite: Sprite2D = $Sprite2D

@onready var _popup: Panel = $Popup
@onready var _texture_rect: TextureRect = $Popup/VBoxContainer/TextureRect
@onready var _label: Label = $Popup/VBoxContainer/Label

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
	_assign_stats()


func _assign_stats() -> void:
	_sprite.texture = stats.texture
	_texture_rect.texture = stats.texture
	_label.text = stats.name


func _display_popup() -> void:
	_popup.show()
	gameplay_events.emit_signal("weapon_detected", stats)


func _on_area_entered(_area: Area2D) -> void:
	_display_popup()
	gameplay_events.connect("weapon_dropped", _on_GameplayEvents_weapon_dropped)


func _on_area_exited(_area: Area2D) -> void:
	_popup.hide()
	gameplay_events.emit_signal("weapon_undetected")
	gameplay_events.disconnect("weapon_dropped", _on_GameplayEvents_weapon_dropped)


func _on_GameplayEvents_weapon_dropped(weapon_stats: WeaponStats) -> void:
	if weapon_stats == null:
		queue_free()
		return
	
	stats = weapon_stats
	
	_assign_stats()
	_display_popup()
	
	_animation_player.play("Drop")
	await _animation_player.animation_finished
	_animation_player.play("Idle")
