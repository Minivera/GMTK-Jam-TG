extends Node

var empty_texture = load("res://assets/empty.PNG")
var headquarters_texture = load("res://assets/headquarters.PNG")

var holding_building = null;

func get_texture_by_type(type):
	if type == "headquarters":
		return headquarters_texture
	return empty_texture
