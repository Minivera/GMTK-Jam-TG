extends Node

const cell_size = 96
const margin_size = 12

var empty_texture = load("res://assets/empty.PNG")
var headquarters_texture = load("res://assets/headquarters.PNG")
var energy_texture = load("res://assets/energy.PNG")
var bank_texture = load("res://assets/cash.PNG")
var restaurant_texture = load("res://assets/food.PNG")

var holding_building = null;

var known_multi_buildings = [
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

func get_multi_building(label):
	for multi_building in known_multi_buildings:
		if multi_building["label"] == label:
			return multi_building
	return null;

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
