extends Node

var energy = 500
var energy_max = 500
const energy_increase = 250

var food = 300
var food_max = 300
const food_increase = 250

var alloy = 250
var alloy_max = 300
const alloy_increase = 100

var gas = 100
var gas_max = 200
const gas_increase = 75

var science = 0
var science_max = 500
const science_increase = 200

func increase_max():
	energy_max += energy_increase
	food_max += food_increase
	alloy_max += alloy_increase
	gas_max += gas_increase
	science_max += science_increase

func _change(type, amount):
	if type == "energy":
		energy = clamp(energy + amount, 0, energy_max)
		return
	if type == "food":
		food = clamp(food + amount, 0, food_max)
		return
	if type == "alloy":
		alloy = clamp(alloy + amount, 0, alloy_max)
		return
	if type == "gas":
		gas = clamp(gas + amount, 0, gas_max)
		return
	if type == "science":
		science = clamp(science + amount, 0, science_max)
		return

func increase_food(amount):
	_change("food", amount)

func decrease_food(amount):
	_change("food", -amount)

func increase_energy(amount):
	_change("energy", amount)

func decrease_energy(amount):
	_change("energy", -amount)

func increase_alloy(amount):
	_change("alloy", amount)

func decrease_alloy(amount):
	_change("alloy", -amount)

func increase_gas(amount):
	_change("gas", amount)

func decrease_gas(amount):
	_change("gas", -amount)

func increase_science(amount):
	_change("science", amount)

func decrease_science(amount):
	_change("science", -amount)
