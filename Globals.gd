extends Node

var empty_texture = load("res://assets/empty.PNG")
var headquarters_texture = load("res://assets/headquarters.PNG")
var energy_texture = load("res://assets/energy.PNG")
var bank_texture = load("res://assets/cash.PNG")
var restaurant_texture = load("res://assets/food.PNG")

var holding_building = null;

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
