extends Node2D


# Declare member variables here. Examples:
const rows = 15
const cols = 5

const scroll_speed = 7

onready var globals = get_node("/root/Globals")

var max_scroll
var motion = Vector2()
const still = Vector2(0, 0)

# Keep a reference to all the rooms
var rooms = []
var buildings = []
var hovered = null
signal building_created(objects)

onready var Room = preload("res://Room.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var cell_size = globals.cell_size
	var margin_size = globals.margin_size
	
	for i in range(rows):
		for j in range(cols):
			var room = Room.instance()
			room.offset = {
				"x": cell_size * j + margin_size * j,
				"y": cell_size * i + margin_size * i
			}
			room.grid_position = Vector2(j, i)
			room.size = Vector2(cell_size, cell_size)
			room.type = "empty"
			room.connect("room_entered", self, "_on_room_entered")
			rooms.append(room)
			$Position2D/Camera2D.add_child(room)
	
	$Position2D/Camera2D.set_limit(MARGIN_TOP, 0)
	$Position2D/Camera2D.set_limit(MARGIN_BOTTOM, cell_size * rows + margin_size * rows)
	max_scroll = cell_size * rows + margin_size * rows


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			motion = Vector2(0, scroll_speed)
		if event.button_index == BUTTON_WHEEL_UP:
			motion = Vector2(0, -scroll_speed)

func _physics_process(delta):
	var speed = 256 * delta
	if motion.abs() != still:
		$Position2D.translate(-motion * speed)
		motion = still


func _on_room_entered(room):
	hovered = room


func _has_created_building():
	var created = _verify_building_creation()
	while created:
		for room in created["rooms"]:
			room.is_part_of_building = true
		
		buildings.append({
			"rooms": created["rooms"],
			"label": created["building"]["label"],
			"name": created["building"]["name"]
		})
		emit_signal("building_created", created)
		created = _verify_building_creation()


func _verify_building_creation():
	# For each of the rooms in the game world
	for room in rooms:
		# Skip this room if it already is a part of a building
		if room.is_part_of_building:
			continue
		
		# Loop in all the possible buildings a player can create
		# TODO: Limit this to the buildings the player has unlocked
		for building in globals.known_buildings:
			# Get the types that make up this building
			var elements = globals.get_building_makeup(building)
			
			# Only check if a building has been created if the room's type
			# is one of the possible types for that building. Small optimization
			# that will probably not help anything
			if !elements.has(room.type):
				continue
			
			# For each possible shape
			for building_shape in building["shapes"]:
				var result = _verify_building_shape(building_shape, room)
				
				# If we found a building, result will have all the rooms we should link together
				if result:
					return {
						"building": building,
						"rooms": result
					}
	
	return null

func _verify_building_shape(building_shape, room):
	# Get the position of that room in the shape
	var position_in_building = Vector2()
	for i in range(building_shape.size()):
		for j in range(building_shape[i].size()):
			if building_shape[i][j] == room.type:
				position_in_building = Vector2(j, i)
	
	var rooms_of_building = []
	# Start checking the rows above the current position
	for i in range(position_in_building.y):
		# Check all the columns for each of those rows
		for j in range(building_shape[i].size()):
			var found_room = _find_room(Vector2(
				room.grid_position.x - (position_in_building.x - j),
				room.grid_position.y - (position_in_building.y - i)
			))
			
			if building_shape[i][j] == null:
				continue
			
			if !found_room or found_room.type != building_shape[i][j]:
				# If we couldn't find a room, the shape is impossible
				return false
			
			rooms_of_building.append(found_room)
			
	
	# Now check the columns for the current row
	for j in range(building_shape[position_in_building.y].size()):
		var found_room = _find_room(Vector2(
			room.grid_position.x - (position_in_building.x - j),
			room.grid_position.y
		))
		
		if building_shape[position_in_building.y][j] == null:
			continue
		
		if !found_room or found_room.type != building_shape[position_in_building.y][j]:
			# If we couldn't find a room, the shape is impossible
			return false
		
		rooms_of_building.append(found_room)
		
	# Finally, check the room bellow the current position
	for i in range(position_in_building.y + 1, building_shape.size()):
		# Check all the columns for each of those rows
		for j in range(building_shape[i].size()):
			var found_room = _find_room(Vector2(
				room.grid_position.x - (position_in_building.x - j),
				room.grid_position.y + i
			))
			
			if building_shape[i][j] == null:
				continue
			
			if !found_room or found_room.type != building_shape[i][j]:
				# If we couldn't find a room, the shape is impossible
				return false
			
			rooms_of_building.append(found_room)
	
	return rooms_of_building

func _find_room(given_pos):
	# Make sure we're not trying to find rooms that are out of bounds
	if given_pos.x >= rows or given_pos.y >= cols or given_pos.x < 0 or given_pos.y < 0:
		return null
	
	# Try to find a room for the specific position
	for room in rooms:
		if room.grid_position == given_pos and !room.is_part_of_building:
			return room
	
	return null

func drop():
	if hovered && globals.holding_room != "empty":
		hovered.type = globals.holding_room
		hovered = null
		_has_created_building()
