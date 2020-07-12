extends Node

const cell_size = 160
const margin_size = 0

var empty_room = load("res://Rooms/BasicRoom.tscn")
var computer_room = load("res://Rooms/ComputerRoom.tscn")
var pod_room = load("res://Rooms/PodRoom.tscn")

var computer_texture = load("res://assets/props/big-computer.png")
var pod_texture = load("res://assets/props/cryo-pod.png")

var holding_room = null;

var known_buildings = [
	{
		"label": "mall",
		"name": "Mall",
		"shapes": [
			[
				["energy"],
				["bank"],
				["restaurant"]
			],
			[
				["energy", "bank", "restaurant"],
			]
		],
	},
	{
		"label": "political_center",
		"name": "Political Center",
		"shapes": [
			[
				["energy", null],
				["headquarters", "bank"]
			],
			[
				[null, "energy"],
				["bank", "headquarters"]
			],
			[
				["bank", "headquarters"],
				[null, "energy"]
			],
			[
				["headquarters", "bank"],
				["energy", null]
			],
		],
	}
]

func get_building(label):
	for building in known_buildings:
		if building["label"] == label:
			return building
	return null;

func get_building_makeup(building):
	var elements = []
	
	for shape in building["shapes"]:
		for row in shape:
			for column in row:
				if column != null and !elements.has(column):
					elements.append(column)
	
	return elements

func get_scene_by_type(type):
	if type == "computer":
		return computer_room.instance()
	elif type == "pod":
		return pod_room.instance()
	return empty_room.instance()
