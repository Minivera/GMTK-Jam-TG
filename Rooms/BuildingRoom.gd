extends Control


export (float) var build_amount = false setget _set_build_amount

func _set_build_amount(new_build_amount):
	build_amount = new_build_amount
	$Background/ProgressBar.value = new_build_amount
