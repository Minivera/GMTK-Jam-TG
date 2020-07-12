extends Control


export (int) var infection_level = false setget _set_infection_level


# Called when the node enters the scene tree for the first time.
func _ready():
	_change_tiles()


func _change_tiles():
	var sections = [
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(2, 0),
		Vector2(3, 0),
		Vector2(4, 0),
		Vector2(0, 1),
		Vector2(4, 1),
		Vector2(0, 2),
		Vector2(4, 2),
		Vector2(0, 3),
		Vector2(4, 3),
		Vector2(0, 4),
		Vector2(1, 4),
		Vector2(2, 4),
		Vector2(3, 4),
		Vector2(4, 4),
	]
	
	# This array mirrors the above array, but tells which tile to use instead
	var tiles = [
		0, 1, 1, 1, 2, 3, 4, 3, 4, 3, 4, 5, 6, 6, 6, 7
	]
	for i in range(sections.size()):
		$Background/BaseWalls.set_cellv(sections[i], tiles[i] + 8 * infection_level)

func _set_infection_level(new_infection_level):
	infection_level = new_infection_level
	_change_tiles()
