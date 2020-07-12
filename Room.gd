extends Node2D


# Declare member variables here. Examples:
export ({}) var offset
export (Vector2) var grid_position
export (Vector2) var size
export (String) var type setget _set_type
export (bool) var is_part_of_building = false


onready var globals = get_node("/root/Globals")
signal room_entered(object)
signal room_exited(object)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.position.x = offset["x"]
	$Area2D.position.y = offset["y"]
	$Area2D/CollisionPolygon2D.polygon = PoolVector2Array([
		Vector2(0, 0),
		Vector2(size.x, 0),
		size,
		Vector2(0, size.y)
	])
	$Area2D/RoomView.add_child(globals.get_scene_by_type(type))


func _set_type(new_type):
	type = new_type
	for child in $Area2D/RoomView.get_children():
		child.queue_free()

	if globals:
		$Area2D/RoomView.add_child(globals.get_scene_by_type(new_type))


func _on_Area2D_area_entered(area):
	if area.name == "DraggingArea" && globals.holding_room:
		emit_signal("room_entered", self)


func _on_Area2D_area_exited(area):
	if area.name == "DraggingArea" && globals.holding_room:
		emit_signal("room_exited", self)
