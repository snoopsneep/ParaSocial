class_name Gravedigger extends Vessel

@onready var interact_range = $InteractRange

func _ready():
	is_aggro = false
	super()

func _physics_process(_delta):
	super(_delta)
	if _display_left:
		if _display_up: # upleft
			interact_range.position = Vector2(-466,-466)
		else: # downleft
			interact_range.position = Vector2(-466,449)
	else:
		if _display_up: # upright
			interact_range.position = Vector2(466,-466)
		else: # downright
			interact_range.position = Vector2(466,449)
