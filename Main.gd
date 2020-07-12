extends Node2D

onready var globals = get_node("/root/Globals")
onready var resources = get_node("/root/Resources")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		$DraggablePosition.drop()
		$GameGrid.drop()
		globals.holding_room = null

func _on_RoomsList_room_pressed(type):
	$DraggablePosition.pickup(type)
	globals.holding_room = type


func _on_GameGrid_building_created(objects):
	pass


func _on_GameGrid_room_created(room_type):
	for room in globals.known_rooms:
		if room["type"] == room_type:
			for cost in room["costs"]:
				resources._change(cost[0], -cost[1])


func _on_ResourceTimer_timeout():
	for building in globals.constructed_buildings:
		if building["produces"]:
			for production in building["produces"]:
				resources._change(production[0], production[1])
		if building["consumes"]:
			for consumption in building["consumes"]:
				resources._change(consumption[0], -consumption[1])
