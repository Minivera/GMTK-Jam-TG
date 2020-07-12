extends Node2D


# Declare member variables here. Examples:
export ({}) var offset
export (Vector2) var grid_position
export (Vector2) var size
export (String) var type setget _set_type
export (bool) var is_part_of_building = false
export (bool) var is_infected = false setget _set_infected
export (int) var infection_level = false setget _set_infection_level

var building_type = null

onready var globals = get_node("/root/Globals")
var building_room = load("res://Rooms/BuildingRoom.tscn")

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


func _set_infected(new_is_infected):
	is_infected = new_is_infected
	infection_level = 1
	$Area2D/RoomView.get_children()[0].infection_level = infection_level


func _set_infection_level(new_infection_level):
	infection_level = new_infection_level
	$Area2D/RoomView.get_children()[0].infection_level = infection_level


func build(new_type):
	if type == "filled" or type != "empty" or building_type:
		return

	building_type = new_type
	for child in $Area2D/RoomView.get_children():
		child.queue_free()
	
	var building = building_room.instance()
	building.build_amount = $ConstructionTimer.wait_time
	$Area2D/RoomView.add_child(building)
	$ConstructionTimer.start()

func _on_Area2D_area_entered(area):
	if area.name == "DraggingArea" && globals.holding_room:
		emit_signal("room_entered", self)


func _on_Area2D_area_exited(area):
	if area.name == "DraggingArea" && globals.holding_room:
		emit_signal("room_exited", self)


func _on_ConstructionTimer_timeout():
	_set_type(building_type)
