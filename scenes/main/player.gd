class_name Player extends Node2D
## The player controller, which controls all the vessels remotely.
##
## The player class is (currently) connected to a node in the main game scene.
## It stores a reference to another "vessel" node, handles the player inputs, and
## passes those inputs to its current vessel.

# TODO: have player script store current parasite health, and spawn parasites
# with the current health (it currently spawns it at full health every time)

## Holds a reference to whatever vessel the player starts in. Exported, so you
## should set it in the Inspector.
@export var first_vessel: CharacterBody2D

## Holds a reference to the vessel the player is currently controlling.
var curr_vessel: CharacterBody2D

# can probably be replaced by a simple "if curr_vessel is type Parasite"
## If [code]true[/code], the player is currently controlling a parasite
var is_parasite: bool = false

signal parasite(pos,vel) ## Emits when the parasite is spawned.
signal hurt(hp,max_hp) ## Emits when the player

func _ready():
	# sets the player into the first vessel. allows you to start in whatever vessel
	# you want, for debug purposes! :)
	# (has to be call_deferred so the hp is set first)
	call_deferred("new_vessel", first_vessel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if curr_vessel != null: # only process if there IS a vessel
		# this variable assignment also gets the player's input vector
		var direction = Input.get_vector("left","right","up","down")
		# if direction isn't 0,0 (aka "if the player is inputting movement")
		if direction != Vector2(0.0,0.0):
			# set velocity (which is used by move_and_slide()
			curr_vessel.velocity = direction * curr_vessel.speed
		else: # if direction IS 0,0 (aka "if the player ISN'T moving")
			# this decelerates the player REALLY fast. turn down the second parameter
			# to reduce friction (makes ice physics! kinda!)
			curr_vessel.velocity = curr_vessel.velocity.move_toward(Vector2(0,0), 50)
		# move_and_slide() actually moves the vessel (and does collision)
		curr_vessel.move_and_slide()

		# if the player just pressed the possess button
		if Input.is_action_just_pressed("Possess Button"):
			if not is_parasite: # if they're NOT currently the parasite
				leave_vessel() # leave the vessel they're in
			else: # if they ARE currently just the parasite
				curr_vessel.possess() # run the parasite's possess function

		# always set the Player node's position (and the camera's position by extension)
		# to the current vessel's position
		position = curr_vessel.position

## Used when the player leaves a vessel. Emits the [signal Player.parasite] signal
## which links to [method Game.spawn_parasite].
func leave_vessel():
	parasite.emit(curr_vessel.position)

# TODO: make this documentation connect to the Vessel.hurt signal when you make that class
## Method that catches the [code]Vessel.hurt[/code] signal and passes it with
## [signal Player.hurt] up to [method Game._on_update_hp].
func pass_hurt(hp,max_hp):
	hurt.emit(hp,max_hp)

# TODO: make the disconnecting part of this function a separate function it runs first
# (it'll make stuff like starting as any vessel in the scene easier)
## Function that catches [signal Parasite.new_vessel] and switches the Player's
## current vessel to the node specified in [param body], connecting signals and
## stuff along the way.
func new_vessel(body,is_para = false):
	if curr_vessel: # this stops the method from disconnecting signals on first run
		# disconnect signals from old vessel before changing!!
		curr_vessel.disconnect("hurt", pass_hurt)
		curr_vessel.disconnect("boot", leave_vessel)
		# tell the old vessel it ISN'T the vessel anymore!!
		curr_vessel.is_vessel = false
	# change curr_vessel to the new vessel!!
	curr_vessel = body
	# tell the new vessel what's up
	curr_vessel.is_vessel = true
	# connect the new vessel's signals
	curr_vessel.connect("hurt", pass_hurt)
	curr_vessel.connect("boot", leave_vessel)
	# if the vessel's dead, revive it with half health
	if curr_vessel.health == 0:
		curr_vessel.health = floor(curr_vessel.max_health / 2)
	# pass the health value up to the Game node to update the display
	pass_hurt(curr_vessel.health,curr_vessel.max_health)
	# if the new vessel is the parasite (because, yes, the parasite is a vessel)
	if is_para:
		# connect the parasite's signal for possessing stuff
		curr_vessel.connect("new_vessel", new_vessel)
		# tell this node that we're the parasite now!!
		is_parasite = true
	else:
		# tell this node that we're NOT the parasite anymore!!
		is_parasite = false
