extends Node2D


# Declare member variables here. Examples:
export ({}) var offset
export (Vector2) var size
export (String) var type
export (Texture) var texture setget _set_texture


onready var globals = get_node("/root/Globals")
signal building_entered(object)
signal building_exited(object)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/Sprite.region_rect = Rect2(Vector2(0, 0), size)
	$Area2D/Sprite.offset.x = offset["x"] + size.x / 2
	$Area2D/Sprite.offset.y = offset["y"] + size.y / 2
	$Area2D/CollisionPolygon2D.polygon = PoolVector2Array([
		Vector2(0, 0),
		Vector2(size.x, 0),
		size,
		Vector2(0, size.y)
	])
	$Area2D/CollisionPolygon2D.transform.origin.x = offset["x"]
	$Area2D/CollisionPolygon2D.transform.origin.y = offset["y"]
	$Area2D/Sprite.texture = texture


func _set_texture(new_texture):
	texture = new_texture
	$Area2D/Sprite.texture = new_texture


func _on_Area2D_area_entered(area):
	if area.name == "DraggingArea" && globals.holding_building:
		emit_signal("building_entered", self)


func _on_Area2D_area_exited(area):
	if area.name == "DraggingArea" && globals.holding_building:
		emit_signal("building_exited", self)
