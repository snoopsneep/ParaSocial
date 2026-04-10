extends WorldObject

@onready var left: Vector2 = $LeftPoint.global_position
@onready var middle: Vector2 = $Middle.global_position
@onready var right: Vector2 = $RightPoint.global_position

@export var bench_specific_z_index: int

func _ready():
	z_index = bench_specific_z_index

func _physics_process(_delta):
	super(_delta)
	#print(check_overlap())

# if true, actor is behind object
# (only returns true if actor is above right & between right and middle OR
# if actor is between right and left, but above the middle point)
func check_overlap(hitbox: Node2D) -> bool:
	var pos: Vector2 = hitbox.get_parent().global_position
	# if the actor is above and to the right of the left marker
	if (pos.y < left.y) and (pos.x > left.x):
		if pos.x < middle.x: # if above left and between left & middle horizontally
			return true
		# if above mid & to the left of the right marker
		elif (pos.y < middle.y) and (pos.x < right.x) and (pos.y < right.y):
			return true
		else:
			return false
	else:
		return false
