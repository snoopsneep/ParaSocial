class_name Rat extends Vessel
## The Rat vessel - small and quick, can fit in small places!

## The direction that the rat is traveling in (if not the vessel)
var direction = Vector2(0.0, 0.0).normalized()

## Is the rat scared?
var scared = false
var target = null

# set default values on initialization
func _ready():
	can_vessel = true
	super()

# runs once a frame (i think)
func _physics_process(_delta):
	# if the player is in this vessel
	if is_vessel:
		set_collision_layer_value(1, true) # set the player collision to true
	else: # if the vessel is empty
		set_collision_layer_value(1, false) # set the player collision to false
		is_aggro = false # make enemies not attack it

	if !is_vessel: # when it's just a rat
		if scared:
			# this fixes weirdness when the player captures near him
			if target == null:
				for i in $ScaredRange.get_overlapping_bodies():
					if i is Vessel and i.is_vessel == true:
						target = i
			if target == null:
				scared = false
			else:
				direction = (target.position - position).normalized() # player pos
				direction *= -1 # invert to run AWAY
				velocity = direction * speed
				move_and_slide()

	# do the animation stuff in Vessel
	super(_delta)

func _on_interact_range_body_entered(body: Node2D) -> void:
	target = body # assign the thing in range to target
	if target.is_vessel: # If target is aggro...
		scared = true # ...run.
		$ScaredRange.scale *= 1.5

func _on_interact_range_body_exited(body: Node2D) -> void:
	# if is vessel, calm down.
	if body.is_vessel:
		scared = false
		target = null
		$ScaredRange.scale /= 1.5
