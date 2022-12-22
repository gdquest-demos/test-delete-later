extends State
class_name GoblinState

var goblin: Goblin
var player: Player


func _ready() -> void:
	super._ready()
	
	await owner.ready

	goblin = owner
	player = owner.main_instances.player
