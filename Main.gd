extends Node2D

onready var globals = get_node("/root/Globals")
onready var resources = get_node("/root/Resources")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		$DraggablePosition.drop()
		$GameGrid.drop()
		$DropSfx.play()
		globals.holding_room = null

func _on_RoomsList_room_pressed(type):
	$DraggablePosition.pickup(type)
	globals.holding_room = type


func _on_GameGrid_building_created(objects):
	# If we create a building that produces gas, let's start the infection timer
	for production in objects["building"]["produces"]:
		if production[0] == "gas":
			# Start the timer
			# TODO: maybe we can increase the challenge by decreasing the timer time based on the amount of gas produced?
			$InfectionTimer.start(globals.infection_speed)


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


func _on_InfectionTimer_timeout():
	$GameGrid.process_infection()
