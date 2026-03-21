class_name Parasite extends Vessel
## The Parasite vessel - even MORE of the default

## Reference variable to the parasite's capture range
@onready var sight = $Sight

## Reference variable to the parasite's death timer
@onready var death_timer = $"Death Timer"

## Signal that emits when the parasite picks the new body to capture
signal new_vessel(body)

func _ready():
	super()
	# make the parasite invincible for the first 0.4 seconds of its existence
	# (so that it doesn't instantly die when the vessel it's in dies)
	$Hurtbox/CollisionShape2D.disabled = true
	await get_tree().create_timer(0.4).timeout
	$Hurtbox/CollisionShape2D.disabled = false

func _physics_process(_delta):
	# if there's 1 - 1.75 seconds left before it dies and you can't see the warning yet
	if ((1 < death_timer.time_left) && (death_timer.time_left < 1.75)):
		pass # TODO: tell the player when they're about to die (as parasite)

	# run the animations from Vessel
	super(_delta)

## Slightly edited hit method actually kills the player rather than booting them out
func hit(dmg = 1):
	health -= dmg
	if health <= 0:
		_on_death()
	hurt.emit(health,max_health)

## Finds the closest valid vessel and emits [signal Parasite.new_vessel] to tell the
## player script to switch em'
func possess():
	if sight.has_overlapping_bodies():
		var closest_body
		var closest_dist: float = 9999999.0
		# TODO: make this function raycast towards its target,
		# so you can't just possess enemies through walls.
		for i in sight.get_overlapping_bodies():
			if (position.distance_to(i.position) < closest_dist):
				closest_dist = position.distance_to(i.position)
				closest_body = i
		new_vessel.emit(closest_body)

		# fixes a bug where rooms don't transition if you capture over them
		for i in sight.get_overlapping_areas():
			if i is RoomTransition:
				i.trigger(closest_body)

		# deletes the parasite
		queue_free()

func _on_death():
	death_timer.stop()
	# get_tree().current_scene is the Game node, from there we grab the
	# event manager w/ its reference variable, then we grab the game_over
	# node from within the event manager, THEN we call the game_over() function
	get_tree().current_scene.event_manager.game_over.game_over()

# overrides interact method so you CAN'T use it to interact
func interact():
	pass
