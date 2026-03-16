class_name Rat extends Vessel
## The Rat vessel - small and quick, can fit in small places!

## The direction that the rat is traveling in (if not the vessel)
var direction = Vector2(randf(),randf()).normalized()

# set default values on initialization
func _ready():
	health = max_health
	can_vessel = true
	is_aggro = false
	speed = 200.0

# runs once a frame (i think)
func _physics_process(delta):

	# if the player is in this vessel
	if is_vessel:
		set_collision_layer_value(1, true) # set the player collision to true
	else: # if the vessel is empty
		set_collision_layer_value(1, false) # set the player collision to false
		is_aggro = false # make enemies not attack it

	if !is_vessel: # when it's just a rat
		var old_spot = position
		old_spot.x += 0 + randf_range(-3,3)
		old_spot.y += 0 + randf_range(-5,3)
		var collision = move_and_collide(direction * speed * delta)
		if collision != null:
			var spot = collision.get_position()
			direction = spot.direction_to(old_spot).normalized()
