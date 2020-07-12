extends Node

const cell_size = 160
const margin_size = 0

var empty_room = load("res://Rooms/BasicRoom.tscn")
var computer_room = load("res://Rooms/ComputerRoom.tscn")
var pod_room = load("res://Rooms/PodRoom.tscn")

var computer_texture = load("res://assets/props/big-computer.png")
var pod_texture = load("res://assets/props/cryo-pod.png")

var holding_room = null;

#Headquarters
#Living Quarters
#Farm
#Reactor
#Energy Cell
#Fabricator (Makes alloy)
#Lab
#Pump
#Cryo rooms (Blocks infection)
var known_rooms = [
	{
		"type": "headquarters",
		"costs": [["alloy", 50]]
	},
	{
		"type": "living",
		"costs": [["alloy", 25], ["food", 10]]
	},
	{
		"type": "farm",
		"costs": [["alloy", 35]]
	},
	{
		"type": "reactor",
		"costs": [["alloy", 45]]
	},
	{
		"type": "energy",
		"costs": [["alloy", 35], ["energy", 10]]
	},
	{
		"type": "fabricator",
		"costs": [["alloy", 45]]
	},
	{
		"type": "lab",
		"costs": [["alloy", 55]]
	},
	{
		"type": "pump",
		"costs": [["alloy", 45]]
	},
	{
		"type": "pump",
		"costs": [["alloy", 100], ["energy", 20]]
	}
]
var known_buildings = [
	{
		"label": "political_center",
		"name": "Political Center",
		"unlocks": [
			"food_processing_plant",
			"alloy_production_facility",
			"energy_reactor",
			"operations_center"
		],
		"consumes": [["food", 10]],
		"shapes": [
			[
				["energy", null],
				["headquarters", "living"]
			],
			[
				[null, "energy"],
				["living", "headquarters"]
			],
			[
				["living", "headquarters"],
				[null, "energy"]
			],
			[
				["headquarters", "living"],
				["energy", null]
			],
		],
	},
	{
		"label": "food_processing_plant",
		"name": "Food processing plant",
		"consumes": [["energy", 5]],
		"produces": [["food", 20]],
		"shapes": [
			[
				["farm"],
				["energy"],
				["living"]
			],
			[
				["farm", "energy", "living"],
			],
			[
				["living"],
				["energy"],
				["farm"]
			],
			[
				["living", "energy", "farm"],
			]
		],
	},
]
var unlocked_buildings = ["political_center"]
var constructed_buildings = [{
	"produces": [["energy", 10], ["gas", 5]],
	"consumes": [["alloy", 5], ["food", 5]]
}]

const infection_speed = 180
const new_infection_change = 0.5
const max_infection_level = 3

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
	if type == "headquarters":
		return computer_room.instance()
	elif type == "living":
		return pod_room.instance()
	return empty_room.instance()
