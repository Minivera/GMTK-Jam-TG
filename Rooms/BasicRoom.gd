extends Control


export (int) var infection_level = false setget _set_infection_level

const normalBg = preload("res://assets/backgrounds/background2.png")
const infectedBg =  preload("res://assets/backgrounds/background-infected.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	_change_tiles()
	_change_background()

func _change_background():
	if (infection_level and infection_level > 1):
		$Background.texture = infectedBg
	else:
		$Background.texture = normalBg

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
	# This array contains the multiplier to use depending on the infection level
	var multiplier_per_infection = [0, 1, 1, 2]
	
	for i in range(sections.size()):
		$Background/BaseWalls.set_cellv(sections[i], tiles[i] + 8 * multiplier_per_infection[infection_level])

func _set_infection_level(new_infection_level):
	infection_level = new_infection_level
	_change_tiles()
	_change_background()
