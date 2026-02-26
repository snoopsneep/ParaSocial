class_name Statue extends Vessel
## The statue vessel - sort of the default.
##
## The Statue vessel, or at least the one from the Milestone 1 Prototype.

## Reference variable to the attack cooldown timer.
@onready var atk_cooldown = $"Attack Cooldown"

# a bunch of private reference variables to the attack nodes
#region attack access variables
@onready var _up_attack = $Attacks/UpAttack/CollisionShape2D
@onready var _up_sprite = $Attacks/UpAttack/AnimatedSprite2D
@onready var _left_attack = $Attacks/LeftAttack/CollisionShape2D
@onready var _left_sprite = $Attacks/LeftAttack/AnimatedSprite2D
@onready var _down_attack = $Attacks/DownAttack/CollisionShape2D
@onready var _down_sprite = $Attacks/DownAttack/AnimatedSprite2D
@onready var _right_attack = $Attacks/RightAttack/CollisionShape2D
@onready var _right_sprite = $Attacks/RightAttack/AnimatedSprite2D
#endregion

# set variables on initialization
func _ready():
	health = max_health
	can_vessel = true
	speed = 100.0

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
		if Input.is_action_just_pressed("alt_up") and atk_cooldown.is_stopped():
			_up_attack.disabled = false # un-disable (enable) the attack collider
			_up_sprite.visible = true # make the sprite visible
			_up_sprite.play("default") # make the sprite animation play
			atk_cooldown.start() # start the animation cooldown
		else: if Input.is_action_just_pressed("alt_left") and atk_cooldown.is_stopped():
			_left_attack.disabled = false
			_left_sprite.visible = true
			_left_sprite.play("default")
			atk_cooldown.start()
		else: if Input.is_action_just_pressed("alt_down") and atk_cooldown.is_stopped():
			_down_attack.disabled = false
			_down_sprite.visible = true
			_down_sprite.play("default")
			atk_cooldown.start()
		else: if Input.is_action_just_pressed("alt_right") and atk_cooldown.is_stopped():
			_right_attack.disabled = false
			_right_sprite.visible = true
			_right_sprite.play("default")
			atk_cooldown.start()

# four functions that trigger when each animation finishes
# (there's probably a way to do this by binding the direction as a parameter or smth)
func _on_up_atk_anim_finished():
	_up_attack.disabled = true # re-disable the attack collider
	_up_sprite.stop() # stop the sprite animation (just in case)
	_up_sprite.visible = false # make the attack sprite invisible again

func _on_left_atk_anim_finished():
	_left_attack.disabled = true
	_left_sprite.stop()
	_left_sprite.visible = false

func _on_down_atk_anim_finished():
	_down_attack.disabled = true
	_down_sprite.stop()
	_down_sprite.visible = false

func _on_right_atk_anim_finished():
	_right_attack.disabled = true
	_right_sprite.stop()
	_right_sprite.visible = false

# func that triggers when something collides with any of the attack colliders
func _on_atk_body_entered(body):
	# if the node detected is (inherits from) a Vessel
	if body is Vessel:
		# run that "hit" function
		body.hit()
