extends Control


export (int) var infection_level = false setget _set_infection_level

func _set_infection_level(new_infection_level):
	$Background/BasicRoom.infection_level = infection_level