extends WorldObject

@onready var left: Vector2 = $LeftPoint.global_position
@onready var middle: Vector2 = $Middle.global_position
@onready var right: Vector2 = $RightPoint.global_position

@export var grave_name: String
@export var grave_dates: String
@export_multiline var grave_inscription: String

@export var grave_row: int

func _ready():
	z_index = grave_row

# if true, actor is behind object
# (only returns true if actor is above right & between right and middle OR
# if actor is between right and left, but above the middle point)
func check_overlap(hitbox: Node2D) -> bool:
	var pos: Vector2 = hitbox.get_parent().global_position
	# if the actor is above and to the left of the right marker
	if (pos.y < right.y) and (pos.x < right.x):
		if pos.x > middle.x: # if above right and between right & middle horizontally
			return true
		# if above mid & to the right of the left marker
		elif (pos.y < middle.y) and (pos.x > left.x):
			return true
		else:
			return false
	else:
		return false
