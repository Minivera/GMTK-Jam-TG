extends Control


export (int) var infection_level = false setget _set_infection_level

func _set_infection_level(new_infection_level):
	infection_level = new_infection_level
	if $Background/BasicRoom:
		$Background/BasicRoom.infection_level = infection_level
