extends Control

onready var globals = get_node("/root/Globals")
onready var resources = get_node("/root/Resources")

const green = "#0ec940"
const red = "#b52212"

var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += delta
	# TODO: configure this better
	if progress > 2.5:
		progress = 0
	
	_update()


func _update():
	$VSplitContainer/VBoxContainer/Grid/EnergyAmount.set_text(String(resources.energy))
	$VSplitContainer/VBoxContainer/Grid/FoodAmount.set_text(String(resources.food))
	$VSplitContainer/VBoxContainer/Grid/AlloyAmount.set_text(String(resources.alloy))
	$VSplitContainer/VBoxContainer/Grid/GasAmount.set_text(String(resources.gas))
	$VSplitContainer/VBoxContainer/Grid/ScienceAmount.set_text(String(resources.science))
	
	var changes = {
		"energy": 0,
		"food": 0,
		"alloy": 0,
		"gas": 0,
		"science": 0,
	}
	for building in globals.constructed_buildings:
		if building["produces"]:
			for production in building["produces"]:
				changes[production[0]] += production[1]
		if building["consumes"]:
			for consumption in building["consumes"]:
				changes[consumption[0]] -= consumption[1]
	
	$VSplitContainer/VBoxContainer/Grid/EnergyIncrease.set_text(
		("+" if changes["energy"] >= 0 else "") +
		String(changes["energy"])
	)
	$VSplitContainer/VBoxContainer/Grid/EnergyIncrease.add_color_override(
		"font_color",
		(green if changes["energy"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Grid/FoodIncrease.set_text(
		("+" if changes["food"] >= 0 else "") +
		String(changes["food"])
	)
	$VSplitContainer/VBoxContainer/Grid/FoodIncrease.add_color_override(
		"font_color",
		(green if changes["food"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Grid/AlloyIncrease.set_text(
		("+" if changes["alloy"] >= 0 else "") +
		String(changes["alloy"])
	)
	$VSplitContainer/VBoxContainer/Grid/AlloyIncrease.add_color_override(
		"font_color",
		(green if changes["alloy"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Grid/GasIncrease.set_text(
		("+" if changes["gas"] >= 0 else "") +
		String(changes["gas"])
	)
	$VSplitContainer/VBoxContainer/Grid/GasIncrease.add_color_override(
		"font_color",
		(green if changes["gas"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Grid/ScienceIncrease.set_text(
		("+" if changes["science"] >= 0 else "") +
		String(changes["science"])
	)
	$VSplitContainer/VBoxContainer/Grid/ScienceIncrease.add_color_override(
		"font_color",
		(green if changes["science"] >= 0 else red)
	)
	
	$VSplitContainer/VBoxContainer2/ProductionProgress.value = progress
