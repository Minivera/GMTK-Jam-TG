extends Node

const cell_size = 96
const margin_size = 12

var empty_texture = load("res://assets/empty.PNG")
var headquarters_texture = load("res://assets/headquarters.PNG")
var energy_texture = load("res://assets/energy.PNG")
var bank_texture = load("res://assets/cash.PNG")
var restaurant_texture = load("res://assets/food.PNG")

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

func get_texture_by_type(type):
	if type == "headquarters":
		return headquarters_texture
	elif type == "energy":
		return energy_texture
	elif type == "bank":
		return bank_texture
	elif type == "restaurant":
		return restaurant_texture
	return empty_texture
