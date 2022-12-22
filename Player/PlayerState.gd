extends State
class_name PlayerState

var player: Player
var skin: PlayerSkin
var climb_detector: ClimbDetector

var projectile_spawner: Marker2D
var collision_boxes: Marker2D
var hit_box: HitBox

var stats: PlayerStats

func _ready() -> void:
	super._ready()
	await owner.ready
	
	player = owner
	skin = owner.skin
	climb_detector = owner.climb_detector
	
	projectile_spawner = owner.projectile_spawner
	collision_boxes = owner.collision_boxes
	hit_box = owner.hit_box
	
	stats = owner.stats
