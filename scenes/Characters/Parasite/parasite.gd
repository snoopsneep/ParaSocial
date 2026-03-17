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

# some variables for making the sprite display nice
var _display_left: bool = false # if true, going left. else, going right
var _display_up: bool = false # if true, going up. else, going down.

# set variables on initialization
func _ready():
	health = max_health
	speed = 600.0

func _physics_process(_delta):
	# if there's 1 - 1.75 seconds left before it dies and you can't see the warning yet
	if ((1 < death_timer.time_left) && (death_timer.time_left < 1.75)) && !warning.visible:
		warning.visible = true # show the warning

	# setting the sprite of the statue based on movement
	# up/right is -100x, down/left is 2250x, down/right is 4650x, up/left is 7000x

	if Input.is_action_pressed("left"):
		_display_left = true
	if Input.is_action_pressed("right"):
		_display_left = false
	if Input.is_action_pressed("down"):
		_display_up = false
	if Input.is_action_pressed("up"):
		_display_up = true
	# if the player is moving horizontally but NOT vertically, always
	# show the camera-facing sprite.
	if velocity.y == 0.0 and velocity.x != 0.0:
		_display_up = false

	if _display_left:
		if _display_up:
			$Sprite2D.region_rect = Rect2(3313,0,1071,829)
		else:
			$Sprite2D.region_rect = Rect2(1071,0,1071,829)
	else: # moving right
		if _display_up:
			$Sprite2D.region_rect = Rect2(0,0,1071,829)
		else:
			$Sprite2D.region_rect = Rect2(2142,0,1071,829)

## Slightly edited hit method actually kills the player rather than booting them out
func hit(dmg = 1):
	health -= dmg
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
	$Sight/CollisionShape2D.disabled = true
	speed = 0
	death_timer.stop()
