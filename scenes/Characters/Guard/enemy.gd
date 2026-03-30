class_name Enemy extends Vessel
## The basic Enemy Vessel template, from the Milestone 1 Presentation

@export_enum("DownLeft", "DownRight", "UpLeft", "UpRight", "Potato", "Leader") var default_sprite: String

@export var enemy_speed: float = 250.0
@export var vessel_speed: float = 300.0
@export var damage: int = 4

## Patrol vars used for routing guard during inactive moments
@export var patrol_route = [Vector2(0.0, 0.0)] ## ONLY STORE vector2d INSIDE
var patrol_index = 0
var desired_location : Vector2
@onready var wait = $"PauseTimer"

## This function controls enemy state
var state = "patrol"
# patrol = moving to next spot
# pause = standing still
# called = moving to called location.
# aggro = agressive
var aggro_target = null
@onready var range = $"Range"

## Reference to navagent used to navigate mesh
@onready var nav = $"NavigationAgent2D"

## Reference to attack cooldown timer
@onready var atk_cooldown = $"Attack Cooldown"

## Reference to damage cooldown timer
@onready var dmg_cooldown = $"Damage Cooldown"

## Reference to death timer
@onready var death_timer = $"Death Timer"

# a bunch of private reference variables to the attack nodes
#region attack access variables
@onready var _attack = $Attack
@onready var _attack_collider = $Attack/CollisionShape2D
@onready var _attack_sprite = $Attack/AnimatedSprite2D
@onready var _range = $Range
#endregion

## If true, enemy is dead
var dead = false

# set variables on initialization
func _ready():
	$Sprite.play(default_sprite)
	speed = enemy_speed
	# navmesh logic

	# set initial target location to first patrol spot
	desired_location = patrol_route[0]

	actor_setup.call_deferred()

	super()

func _physics_process(_delta):
	# set collision layer & mask and modulate
	# Pheo: I dont understand this stuff so i am leaving it here.
	if is_vessel:
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		$Attack.set_collision_mask_value(1, false)
		$Attack.set_collision_mask_value(2, true)
		modulate = Color(1, 1, 1)
		speed = vessel_speed
	else:
		speed = enemy_speed
		if !dead:
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, true)
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, true)
			set_collision_layer_value(6, false)
			$Attack.set_collision_mask_value(1, true)
			$Attack.set_collision_mask_value(2, false)
			modulate = Color(1, 1, 1)
		else:
			modulate = Color(0.561, 0.0, 0.549)
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, false)
			set_collision_layer_value(6, true)
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, false)
	$Hurtbox.collision_layer = collision_layer

	# if it's an enemy
	if !is_vessel:
		if state != "pause":
			move()
		check_aggro()

	# runs the animation code from Vessel
	super(_delta)

# needs to be its own function so the "await" works properly
## The attack that the vessel does when it's an enemy.
func enemy_attack():
	# look at, set collider disbled to false and sprite visible to true
	# set sprite play to default
	# ATK cooldown
	pass ## TODO: make the attack logic (see above)

## Customized hit function deletes the vessel if it dies with the player in it,
## but knocks the enemy unconscious if it's killed as an enemy.
func hit(dmg = 1):
	if dmg_cooldown.is_stopped():
		health -= dmg
		if health <= 0:
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
		## TODO: Add code to aggro when hit

# overrides interact method so you CAN'T use it to interact
func interact():
	pass

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_move_target(desired_location)

# This function just gives the guard a new location to move to.
func set_move_target(target):
	nav.target_position = target

func move():
	# this function runs when it reaches its destination
	if nav.is_navigation_finished():
		print("I have reached my destination!")
		print(patrol_index)
		if state == "called":
			pause(0.2) # between 0.2 - 1.0 seconds
		else:
			pause(0.1) # between 0.1 - 0.5 seconds
	# the actual movement logic
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()

func pause(wait_time):
	state = "pause"
	# the below calculation decides wait time as follows:
	# r % range + min * seconds
	# Generates a number from min to (min + max - 1), multiplies seconds.
	wait.wait_time = (randi() % 5 + 1) * wait_time

	wait.start()
# part of the above pause function
func _on_pause_timer_timeout() -> void:
	print("my break is up!")
	if state == "pause":
		state = "patrol"
		patrol_iterate()

func patrol_iterate():
	patrol_index += 1
	# if index is beyond scope, reset it
	if patrol_index == patrol_route.size():
		patrol_index = 0
	# set next location along path
	set_move_target(patrol_route[patrol_index])

# Literally just here so that other objects can temporarily
# interrupt guard patrol path by overriding current target
func call_guard(location : Vector2):
	state = "called"
	set_move_target(location)

# The following checks if the guard should become aggressive
func check_aggro(): # leaving this seperate incase it needs to be called elsewhere
	# variables for raycasting
	var space_state = get_world_2d().direct_space_state
	var query
	var result

	var bodies = range.get_overlapping_bodies() # get list of all bodies in range

	for body in bodies:
		if body.is_vessel and body.is_aggro: # if is player and is aggro
			# do a raycast
			query = PhysicsRayQueryParameters2D.create(self.global_position, body.global_position)
			result = space_state.intersect_ray(query)
			# and if you collide with target object, aggro
			# if result[Object] == body:
				# print("I see you!")
				# TODO: This broke as I was working on stuff, need to redo it!
# extention of above code, for ease of use
func shout(bodies, call_to):
	for body in bodies:
		pass
		# TODO: Replace this with code that reads if body is guard,
		# then preforms a CALL function to them to player position.

func _on_range_body_exited(body: Node2D) -> void:
	pass
