extends Resource
class_name WeaponStats

enum Type { MELEE, RANGED, SHIELD }

@export var type: Type = Type.MELEE
@export var texture: Texture2D
@export var name: String = ""
