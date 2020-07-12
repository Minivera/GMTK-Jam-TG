extends Node

const cell_size = 160
const margin_size = 0

var filled_room = load("res://Rooms/FilledRoom.tscn")
var empty_room = load("res://Rooms/BasicRoom.tscn")
var computer_room = load("res://Rooms/ComputerRoom.tscn")
var energy_room = load("res://Rooms/Energy Cell.tscn")
var cryo_room = load("res://Rooms/Cryo Room.tscn")
var fabricator_room = load("res://Rooms/Fabricator.tscn")
var farm_room = load("res://Rooms/Farm.tscn")
var lab_room = load("res://Rooms/Lab.tscn")
var living_room = load("res://Rooms/Living Quarters.tscn")
var pump_room = load("res://Rooms/Pump.tscn")
var reactor_room = load("res://Rooms/Reactor.tscn")

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
		"costs": [["alloy", 55], ["science", 5]]
	},
	{
		"type": "pump",
		"costs": [["alloy", 45]]
	},
	{
		"type": "cryo",
		"costs": [["alloy", 100], ["energy", 20], ["science", 5]]
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
	{
		"label": "alloy_production_facility",
		"name": "Alloy production facility",
		"consumes": [["energy", 5]],
		"produces": [["alloy", 20]],
		"shapes": [
			[
				["fabricator"],
				["energy"],
				["living"]
			],
			[
				["fabricator", "energy", "living"],
			],
			[
				["living"],
				["energy"],
				["fabricator"]
			],
			[
				["living", "energy", "fabricator"],
			]
		],
	},
	{
		"label": "energy_reactor",
		"name": "Energy reactor",
		"consumes": [["gas", 5]],
		"produces": [["energy", 30]],
		"shapes": [
			[
				["energy", null],
				["reactor", "lab"],
				["living", null]
			],
			[
				[null, "lab", null],
				["energy", "reactor", "living"],
			],
			[
				["living", null],
				["reactor", "lab"],
				["energy", null]
			],
			[
				["living", "reactor", "energy"],
				[null, "lab", null],
			]
		],
	},
	{
		"label": "operations_center",
		"name": "Operations center",
		"consumes": [["energy", 10]],
		"unlocks": [
			"science_lab",
			"gas_extractor",
			"storage_facility",
			"infection_control_center"
		],
		"shapes": [
			[
				["farm", null],
				["lab", "energy"],
				["living", "headquarters"]
			],
			[
				["living", "lab", "farm"],
				["headquarters", "energy", null],
			],
			[
				["headquarters", "living"],
				["energy", "lab"],
				[null, "farm"]
			],
			[
				[null, "energy", "headquarters"],
				["farm", "lab", "living"],
			]
		],
	},
	{
		"label": "science_lab",
		"name": "Science lab",
		"consumes": [["energy", 5], ["gas", 5]],
		"produces": [["science", 10]],
		"shapes": [
			[
				["lab", "energy"],
				["living", "reactor"]
			],
			[
				["living", "lab"],
				["reactor", "energy"],
			],
			[
				["reactor", "living"],
				["energy", "lab"],
			],
			[
				["energy", "reactor"],
				["lab", "living"],
			]
		],
	},
	{
		"label": "gas_extractor",
		"name": "Gas extractor",
		"consumes": [["energy", 10]],
		"produces": [["gas", 15]],
		"shapes": [
			[
				["pump", "energy", "living", "lab"],
			],
			[
				["pump"],
				["energy"],
				["living"],
				["lab"],
			],
			[
				["lab", "living", "energy", "pump"],
			],
			[
				["lab"],
				["living"],
				["energy"],
				["pump"],
			]
		],
	},
	{
		"label": "storage_facility",
		"name": "Storage facility",
		"consumes": [["energy", 5]],
		"shapes": [
			[
				["pump", "reactor", "lab", "farm", "fabricator"],
			],
			[
				["pump"],
				["reactor"],
				["lab"],
				["farm"],
				["fabricator"]
			],
			[
				["fabricator", "farm", "lab", "reactor", "pump"],
			],
			[
				["fabricator"],
				["farm"],
				["lab"],
				["reactor"],
				["pump"],
			]
		],
	},
	{
		"label": "infection_control_center",
		"name": "Infection control center",
		"shapes": [
			[
				["lab", "headquarters"],
				["pump", "fabricator"],
				["living", "energy"]
			],
			[
				["living", "pump", "lab"],
				["energy", "fabricator", "headquarters"],
			],
			[
				["energy", "living"],
				[ "fabricator", "pump"],
				["headquarters", "lab"],
			],
			[
				["headquarters", "fabricator", "energy"],
				["lab", "pump", "living"],
			]
		],
	},
]
var unlocked_buildings = ["political_center"]
var constructed_buildings = []

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
	if type == "empty":
		return empty_room.instance()
	elif type == "headquarters":
		return computer_room.instance()
	elif type == "living":
		return living_room.instance()
	elif type == "farm":
		return farm_room.instance()
	elif type == "reactor":
		return reactor_room.instance()
	elif type == "energy":
		return energy_room.instance()
	elif type == "fabricator":
		return fabricator_room.instance()
	elif type == "lab":
		return lab_room.instance()
	elif type == "pump":
		return pump_room.instance()
	elif type == "cryo":
		return cryo_room.instance()
	else:
		return filled_room.instance()
