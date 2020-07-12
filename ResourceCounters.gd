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
	$VSplitContainer/VBoxContainer/Energy/Amount.set_text(String(resources.energy))
	$VSplitContainer/VBoxContainer/Food/Amount.set_text(String(resources.food))
	$VSplitContainer/VBoxContainer/Alloy/Amount.set_text(String(resources.alloy))
	$VSplitContainer/VBoxContainer/Gas/Amount.set_text(String(resources.gas))
	$VSplitContainer/VBoxContainer/Science/Amount.set_text(String(resources.science))
	
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
	
	$VSplitContainer/VBoxContainer/Energy/Increase.set_text(
		("+" if changes["energy"] >= 0 else "") +
		String(changes["energy"])
	)
	$VSplitContainer/VBoxContainer/Energy/Increase.add_color_override(
		"font_color",
		(green if changes["energy"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Food/Increase.set_text(
		("+" if changes["food"] >= 0 else "") +
		String(changes["food"])
	)
	$VSplitContainer/VBoxContainer/Food/Increase.add_color_override(
		"font_color",
		(green if changes["food"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Alloy/Increase.set_text(
		("+" if changes["alloy"] >= 0 else "") +
		String(changes["alloy"])
	)
	$VSplitContainer/VBoxContainer/Alloy/Increase.add_color_override(
		"font_color",
		(green if changes["alloy"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Gas/Increase.set_text(
		("+" if changes["gas"] >= 0 else "") +
		String(changes["gas"])
	)
	$VSplitContainer/VBoxContainer/Gas/Increase.add_color_override(
		"font_color",
		(green if changes["gas"] >= 0 else red)
	)

	$VSplitContainer/VBoxContainer/Science/Increase.set_text(
		("+" if changes["science"] >= 0 else "") +
		String(changes["science"])
	)
	$VSplitContainer/VBoxContainer/Science/Increase.add_color_override(
		"font_color",
		(green if changes["science"] >= 0 else red)
	)
	
	$VSplitContainer/VBoxContainer2/ProductionProgress.value = progress
