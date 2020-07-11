extends Node2D

onready var globals = get_node("/root/Globals")

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
