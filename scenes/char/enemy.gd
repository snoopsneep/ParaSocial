class_name Enemy extends Vessel
## The basic Enemy Vessel template, from the Milestone 1 Presentation

## Reference to attack cooldown timer
@onready var atk_cooldown = $"Attack Cooldown"

## Reference to damage cooldown timer
@onready var dmg_cooldown = $"Damage Cooldown"

## Reference to death timer
@onready var death_timer = $"Death Timer"

## Reference to (DEBUG) warning graphic
@onready var warning = $Warning

## Stores a reference to the player when they're in range
var target: Node2D

## Emits to create a projectile on player input or the attack cooldown ending.
signal attack(pos,dir,is_evil)

## If [code]true[/code], this enemy is currently unconscious
var dead = false

# set variables on initialization
func _ready():
	health = max_health
	speed = 60.0
	is_aggro = false

func _physics_process(_delta):
	# set collision layer & mask and modulate
	if is_vessel:
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		modulate = Color(1, 1, 1)
	else:
		if !dead:
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, true)
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, true)
			modulate = Color(1, 1, 1)
		else:
			modulate = Color(0.561, 0.0, 0.549)
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, false)
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, false)

	# if there's 2 - 3 seconds left before it pops you out and you can't see the warning
	if ((2 < death_timer.time_left) && (death_timer.time_left < 3)) && !warning.visible:
		warning.visible = true # make the warning visible

	# if it's an enemy
	if !is_vessel:
		# make it slow
		speed = 60.0
		# if there's a target who is aggro'd (and you're not dead)
		if target != null and !dead and target.is_aggro:
			# move towards the target
			var direction = (target.position - position).normalized()
			velocity = direction * speed
			# if the attack isn't on cooldown
			if atk_cooldown.is_stopped():
				# throw a projectile towards the player (with is_evil set to true)
				attack.emit(position,direction,true)
				# start the attack cooldown
				atk_cooldown.start()
		else: # if this IS an enemy but it doesn't have a target
			velocity = Vector2(0,0) # don't move
		move_and_slide() # apply velocity & collisions to move
	else: # if it's being controlled by the player
		# make it fast
		speed = 180.0

		# if the player uses the primary action
		if Input.is_action_just_pressed("Primary Action"):
			if atk_cooldown.is_stopped(): # and the attack isn't on cooldown
				# set the attack to go towards the mouse
				var atk_dir = (get_global_mouse_position() - position).normalized()
				# shoot the projectile (with is_evil set to false)
				attack.emit(position,atk_dir,false)
				atk_cooldown.start() # start the attack cooldown
				is_aggro = true # make enemies aggro on you

## Customized hit function deletes the vessel if it dies with the player in it,
## but knocks the enemy unconscious if it's killed as an enemy.
func hit():
	if dmg_cooldown.is_stopped():
		health -= 1
		if health == 0:
			if is_vessel:
				boot.emit()
				queue_free()
			else:
				modulate = Color(0.561, 0.0, 0.549)
				dead = true
				set_collision_layer_value(6, true) # make him vessel-able
				death_timer.start()
		dmg_cooldown.start()
		hurt.emit(health,max_health)

# when it has a target
func _on_range_body_entered(body):
	target = body # assign the thing in range to target
	$Range.scale = Vector2(3.5,3.5) # make the range bigger

# when the target leaves its range
func _on_range_body_exited(_body):
	target = null # unassign the target
	$Range.scale = Vector2(2.5,2.5) # make the range smaller

# when the death timer runs out and the enemy wakes back up
func _on_revive():
	warning.visible = false # hide the warning
	dead = false # no longer dead!
	is_aggro = false # enemies shouldn't attack it anymore
	set_collision_layer_value(6, false) # make him not vessel-able anymore
	if health == 0: # if he has no health
		health = floor(float(max_health) / 2) # revive him with half health
	else: # if he has health (if he's been revived by the player)
		if is_vessel: # if he's the player's CURRENT vessel
			boot.emit() # boot the player out of the vessel!!
