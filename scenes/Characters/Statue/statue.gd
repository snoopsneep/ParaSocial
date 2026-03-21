class_name Statue extends Vessel
## The statue vessel - sort of the default.
##
## The Statue vessel, or at least the one from the Milestone 1 Prototype.

# TODO: rename atk_cooldown and atk_delay - they're way too similar.
# the name "atk_cooldown" better fits the functionality of atk_delay, so maybe
# rename atk_cooldown to like "wind_up_delay" or something?

## Reference variable to the attack cooldown timer.
@onready var atk_cooldown = $"Attack Cooldown"
@onready var atk_delay = $"Attack Delay"
@onready var dmg_cooldown = $"Damage Cooldown"

# a bunch of private reference variables to the attack nodes
#region attack access variables
@onready var _attack = $Attack
@onready var _attack_collider = $Attack/CollisionShape2D
@onready var _attack_sprite = $Attack/AnimatedSprite2D
#endregion

# used for logic later on
var atk_chrg = 1
var winding_up: bool = false

# set variables on initialization
func _ready():
	can_vessel = true
	super()

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
		# if the player's currently charging an attack when they leave the statue
		if winding_up:
			atk_chrg = 1
			atk_cooldown.stop()
			winding_up = false
			modulate = Color(1,1,1,1)

	# if the player is in this vessel (yes again. sorry. you can fix it if you want)
	if is_vessel and !Global.player_disabled:
		# checks if the player is pressing attack, and then starts winding up
		# using action_pressed instead of action_just_pressed allows the player
		# to "buffer" an input - if they attack and then immediately start
		# holding the attack button again, it'll start winding up the moment
		# the attack delay ends.
		if Input.is_action_pressed("Primary Action") and atk_delay.is_stopped() and !winding_up:
			# Wind up triggers attack logic.
			_wind_up()
		if Input.is_action_just_released("Primary Action") and winding_up:
			# reset color!
			modulate = Color(1,1,1,1)
			# Run the attack
			_attack.look_at(get_global_mouse_position())
			if atk_chrg == 1:
				_attack.scale /= 3 # make the attack smol when you don't charge it
			_attack_collider.disabled = false # un-disable (enable) the attack collider
			_attack_sprite.visible = true # make the sprite visible
			_attack_sprite.play("default") # make the sprite animation play
			atk_cooldown.stop()
			winding_up = false
			# delay between attacks is called
			atk_delay.start()

	# runs the animation code from Vessel
	super(_delta)
	if _display_left:
		$Hurtbox/CollisionShape2D2.position.x = 80.0
	else:
		$Hurtbox/CollisionShape2D2.position.x = -78.0

func _on_up_atk_anim_finished():
	_attack_collider.disabled = true # re-disable the attack collider
	_attack_sprite.stop() # stop the sprite animation (just in case)
	_attack_sprite.visible = false # make the attack sprite invisible again
	_attack.scale = Vector2(6.3,6.3)
	# reset attack logic vars
	atk_chrg = 1

# func that triggers when a hitbox collides with any of the attack colliders
func _on_atk_area_entered(body: Area2D):
	# if the node detected is (inherits from) a Vessel
	if body.get_parent() is Vessel and body.get_parent() is not Nun:
		# charge state 1 & 2 deal 1 damage, charge state 3 deals 2 damage
		if atk_chrg == 1:
			body.get_parent().hit(atk_chrg)
		else:
			body.get_parent().hit(atk_chrg - 1)

func _wind_up():
	winding_up = true
	# set and start time
	if atk_chrg == 1 or atk_chrg == 2:
		atk_cooldown.wait_time = 1
	else:
		atk_cooldown.wait_time = 1.5
	# set color!
	modulate = Color(1.0, (0.9 - (atk_chrg*0.15)), (0.9 - (atk_chrg*0.15)), 1.0)
	atk_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	# if charge less than max, add 1 to charge and re-call wind up
	if atk_chrg < 3:
		atk_chrg += 1
		_wind_up()

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
