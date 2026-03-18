class_name Rat extends Vessel
## The Rat vessel - small and quick, can fit in small places!

## The direction that the rat is traveling in (if not the vessel)
var direction = Vector2(0.0, 0.0).normalized()

## Is the rat scared?
var scared = false
var target = null

# set default values on initialization
func _ready():
	health = max_health
	can_vessel = true
	is_aggro = false
	speed = 350.0

# runs once a frame (i think)
func _physics_process(delta):

	# if the player is in this vessel
	if is_vessel:
		set_collision_layer_value(1, true) # set the player collision to true
	else: # if the vessel is empty
		set_collision_layer_value(1, false) # set the player collision to false
		is_aggro = false # make enemies not attack it

	if !is_vessel: # when it's just a rat
		if scared:
			direction = (target.position - position).normalized() # player pos
			direction *= -1 # invert to run AWAY
			velocity = direction * speed
			move_and_slide()

func _on_interact_range_body_entered(body: Node2D) -> void:
	target = body # assign the thing in range to target
	if target.is_vessel: # If target is aggro...
		scared = true # ...run.


func _on_interact_range_body_exited(body: Node2D) -> void:
	# if is vessel, calm down.
	if body.is_vessel:
		scared = false
		target = null
		
