class_name Statue extends Vessel
## The statue vessel - sort of the default.
##
## The Statue vessel, or at least the one from the Milestone 1 Prototype.

## Reference variable to the attack cooldown timer.
@onready var atk_cooldown = $"Attack Cooldown"
@onready var dmg_cooldown = $"Damage Cooldown"

# some variables for making the sprite display nice
var _display_left: bool = false # if true, going left. else, going right
var _display_up: bool = false # if true, going up. else, going down.

# a bunch of private reference variables to the attack nodes
#region attack access variables
@onready var _attack = $Attack
@onready var _attack_collider = $Attack/CollisionShape2D
@onready var _attack_sprite = $Attack/AnimatedSprite2D

#endregion

# used for logic later on
var atk_chrg = 1
var atk_ready = true

# set variables on initialization
func _ready():
	health = max_health
	can_vessel = true
	speed = 400.0

# runs once a frame (i think)
func _physics_process(_delta):

	# if the player is in this vessel
	if is_vessel:
		set_collision_layer_value(1, true) # set the player collision to true
		set_collision_layer_value(3, false) # disable the environment collision
		is_aggro = true # make enemies attack it
	else: # if the vessel is empty
		set_collision_layer_value(1, false) # set the player collision to false
		set_collision_layer_value(3, true) # set the environment collision to true
		is_aggro = false # make enemies not attack it

	# if the player is in this vessel (yes again. sorry. you can fix it if you want)
	if is_vessel:
		# checks if the player hits an attack direction, and does the attack.
		if Input.is_action_just_pressed("Primary Action") and atk_ready:
			# Wind up triggers attack logic.
			_wind_up()
		if Input.is_action_just_released("Primary Action"):
			# Run the attack
			_attack.look_at(get_global_mouse_position())
			_attack_collider.disabled = false # un-disable (enable) the attack collider
			_attack_sprite.visible = true # make the sprite visible
			_attack_sprite.play("default") # make the sprite animation play
			atk_cooldown.stop()

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
				$Sprite2D.region_rect = Rect2(7350,0,2450,4200)
				$AnimatedSprite2D.play("UpLeft")
			else:
				$Sprite2D.region_rect = Rect2(2450,0,2450,4200)
				$AnimatedSprite2D.play("DownLeft")
		else: # moving right
			if _display_up:
				$Sprite2D.region_rect = Rect2(0,0,2450,4200)
				$AnimatedSprite2D.play("UpRight")
			else:
				$Sprite2D.region_rect = Rect2(4900,0,2450,4200)
				$AnimatedSprite2D.play("DownRight")

# four functions that trigger when each animation finishes
# (there's probably a way to do this by binding the direction as a parameter or smth)
func _on_up_atk_anim_finished():
	_attack_collider.disabled = true # re-disable the attack collider
	_attack_sprite.stop() # stop the sprite animation (just in case)
	_attack_sprite.visible = false # make the attack sprite invisible again
	# reset attack logic vars
	atk_ready = true
	atk_chrg = 1

# func that triggers when something collides with any of the attack colliders
func _on_atk_body_entered(body):
	# if the node detected is (inherits from) a Vessel
	if body is Vessel:
		# run that "hit" function
		body.hit(atk_chrg)

func _wind_up():
	# So that this function doesnt get called several times
	atk_ready = false

	# set and start time
	if atk_chrg == 1 or atk_chrg == 2:
		atk_cooldown.wait_time = 1
	else:
		atk_cooldown.wait_time = 1.5
	atk_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	# if charge less than max, add 1 to charge and re-call wind up
	if atk_chrg < 3:
		atk_chrg += 1
		_wind_up()
	print("\nAnd your charge is: ", atk_chrg, "!\n")

func hit(dmg = 1):
	if dmg_cooldown.is_stopped():
		health -= dmg
		if health <= 0:
			if is_vessel:
				boot.emit()
				queue_free()
			else:
				modulate = Color(0.561, 0.0, 0.549)
		dmg_cooldown.start()
		hurt.emit(health,max_health)
