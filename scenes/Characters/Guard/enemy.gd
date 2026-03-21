class_name Enemy extends Vessel
## The basic Enemy Vessel template, from the Milestone 1 Presentation

@export_enum("DownLeft", "DownRight", "UpLeft", "UpRight", "Potato", "Leader") var default_sprite: String

@export var enemy_speed: float = 250.0
@export var vessel_speed: float = 300.0

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

## Stores a reference to the player when they're in range
var target: Node2D

## If [code]true[/code], this enemy is currently unconscious
var dead = false

## While seeking true, raycast to player
var seeking = false
## While aggro true, attack player
var aggro = false

# set variables on initialization
func _ready():
	is_aggro = false
	$Sprite.play(default_sprite)
	speed = enemy_speed
	super()

func _physics_process(_delta):
	## call seeking function while seeking
	if seeking:
		_seeking()

	# set collision layer & mask and modulate
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

	# if there's 2 - 3 seconds left before it pops you out and you can't see the warning
	if ((2 < death_timer.time_left) && (death_timer.time_left < 3)):
		pass # TODO: add thing that warns you when ur time is running out

	# if it's an enemy
	if !is_vessel:
		if seeking != null and !dead and aggro:
			# move towards the target
			var direction = (target.position - position).normalized()
			velocity = direction * speed
			# if the attack isn't on cooldown
			if atk_cooldown.is_stopped():
				enemy_attack()
		else: # if this IS an enemy but it doesn't have a target
			velocity = Vector2(0,0) # don't move
		move_and_slide() # apply velocity & collisions to move
	else: # if it's being controlled by the player
		# if the player uses the primary action
		if Input.is_action_just_pressed("Primary Action") and atk_cooldown.is_stopped():
			if atk_cooldown.is_stopped(): # and the attack isn't on cooldown
				_attack.look_at(get_global_mouse_position())
				_attack_collider.disabled = false # un-disable (enable) the attack collider
				_attack_sprite.visible = true # make the sprite visible
				_attack_sprite.play("default") # make the sprite animation play
				# start the attack cooasldown
				atk_cooldown.start()

	# runs the animation code from Vessel
	super(_delta)

# needs to be its own function so the "await" works properly
## The attack that the vessel does when it's an enemy.
func enemy_attack():
	# start the attack cooasldown
	atk_cooldown.start()
	# aim at the target
	_attack.look_at(target.position)
	# delay the attack slightly, so the player can actually dodge
	await get_tree().create_timer(0.2).timeout
	if !dead:
		_attack_collider.disabled = false # un-disable (enable) the attack collider
		_attack_sprite.visible = true # make the sprite visible
		_attack_sprite.play("default") # make the sprite animation play

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
		if !aggro:
			aggro = true
			# put him on cooldown so he can't instantly hit the player
			atk_cooldown.start()
		_shout() # alert the other enemies to the player
		# TODO: close + block the main room doors !!!!!!!!!!!!!!!!!!!!

# TODO: make enemies able to interact with other enemies w/ fun dialogue
# overrides interact method so you CAN'T use it to interact
func interact():
	pass

# when it has a target
func _on_range_body_entered(body):
	target = body # assign the thing in range to target
	if target.is_vessel and (target is Statue or target is Parasite): # If target is aggro...
		seeking = true # ...set me to seeking.
		atk_cooldown.start() # don't attack instantly!

# when the target leaves its range
func _on_range_body_exited(_body):
	target = null # unassign the target
	seeking = false
	aggro = false
	# HACK: commented out for current playtest build
	#_range.scale = Vector2(2.5,2.5) # make the range smaller

# when the death timer runs out and the enemy wakes back up
func _on_revive():
	dead = false # no longer dead!
	is_aggro = false # enemies shouldn't attack it anymore
	set_collision_layer_value(6, false) # make him not vessel-able anymore
	if health == 0: # if he has no health
		health = floor(float(max_health) / 2) # revive him with half health
	else: # if he has health (if he's been revived by the player)
		if is_vessel: # if he's the player's CURRENT vessel
			boot.emit() # boot the player out of the vessel!!

func _seeking():
	## loop while seeking but not aggro
	var space_state = get_world_2d().direct_space_state # Pulls required info for raycast
	## this decides the start and end pos of the ray. Enemy POS, player POS.
	var query = PhysicsRayQueryParameters2D.create(position, target.position)
	var result = space_state.intersect_ray(query) # call the raycast
	if "collider" in result:
		## check if obj hit is player...
		if result.collider == target and target.is_aggro:
			## ...change state to aggro
			aggro = true
			seeking = false
			# HACK: commented out for current playtest build
			#_range.scale = Vector2(3.5,3.5) # make the range bigger


func _on_animated_sprite_2d_animation_finished() -> void:
	_attack_collider.disabled = true # re-disable the attack collider
	_attack_sprite.stop() # stop the sprite animation (just in case)
	_attack_sprite.visible = false # make the attack sprite invisible again


func _on_attack_area_entered(body: Node2D) -> void:
	# if the node detected is (inherits from) a Vessel
	if body.get_parent() is Vessel and body != self:
		# run that "hit" function
		body.get_parent().hit(2)

# HACK: this'll probably have to work differently for the final build
# right now it just makes every enemy (besides the hungry quest guy) aggro
func _shout() -> void:
	for i in get_tree().get_nodes_in_group("Enemies"):
		if i.name != "HungryLeader": # don't rope in the quest guy!!
			if i.aggro == false: # pick a guy that isn't aggro'd yet
				i.target = target # assign my target to that guy
				aggro = true # set them to immediately aggro
				atk_cooldown.start() # and don't let them attack instantly
				i._range.scale *= 10 # make his range really big (so he helps)
				return # and return, so only one guy gets aggro'd
