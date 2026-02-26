class_name Parasite extends Vessel
## The Parasite vessel - even MORE of the default

## Reference variable to the parasite's capture range
@onready var sight = $Sight

## Reference variable to the parasite's death timer
@onready var death_timer = $"Death Timer"

## Reference variable to the little warning graphic (DEBUG)
@onready var warning = $Warning

## Signal that emits when the parasite picks the new body to capture
signal new_vessel(body)

# set variables on initialization
func _ready():
	health = max_health
	speed = 175.0

func _physics_process(_delta):
	# if there's 1 - 1.75 seconds left before it dies and you can't see the warning yet
	if ((1 < death_timer.time_left) && (death_timer.time_left < 1.75)) && !warning.visible:
		warning.visible = true # show the warning

## Slightly edited hit method actually kills the player rather than booting them out
func hit():
	health -= 1
	if health == 0:
		_on_death()
	hurt.emit(health,max_health)

## Finds the closest valid vessel and emits [signal Parasite.new_vessel] to tell the
## player script to switch em'
func possess():
	if sight.has_overlapping_bodies():
		var closest_body
		var closest_dist: float = 9999999.0
		for i in sight.get_overlapping_bodies():
			if (position.distance_to(i.position) < closest_dist):
				closest_dist = position.distance_to(i.position)
				closest_body = i
		new_vessel.emit(closest_body)
		queue_free()

# TODO: when you die as the parasite, you can still press the capture button
# to "come back to life" if something's within capture range
func _on_death():
	$Sprite2D.visible = false
	warning.visible = false
	$CollisionShape2D.disabled = true
	speed = 0
	death_timer.stop()
