extends Node2D

@export var first_vessel: CharacterBody2D
var curr_vessel: CharacterBody2D
var is_parasite: bool = false
var is_aggro: bool = false
signal parasite(pos,vel)
signal hurt(hp,max_hp)

func _ready():
	new_vessel(first_vessel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if curr_vessel != null:
		var direction = Input.get_vector("left","right","up","down")
		if direction != Vector2(0.0,0.0):
			curr_vessel.velocity = direction * curr_vessel.speed
		else:
			curr_vessel.velocity = curr_vessel.velocity.move_toward(Vector2(0,0), 50)
		curr_vessel.move_and_slide()
		if Input.is_action_just_pressed("Possess Button"):
			if !is_parasite:
				leave_vessel()
			else:
				curr_vessel.possess()

	position = curr_vessel.position

func leave_vessel():
	parasite.emit(curr_vessel.position, curr_vessel.velocity)

func pass_hurt(hp,max_hp):
	hurt.emit(hp,max_hp)

# TODO: make the disconnecting part of this function a separate function it runs first
# (it'll make stuff like popping out of enemies on a timer easier)
func new_vessel(body,is_para = false):
	if curr_vessel:
		curr_vessel.disconnect("hurt", pass_hurt)
		curr_vessel.disconnect("boot", leave_vessel)
		curr_vessel.is_vessel = false
	curr_vessel = body
	curr_vessel.is_vessel = true
	curr_vessel.connect("hurt", pass_hurt)
	curr_vessel.connect("boot", leave_vessel)
	if curr_vessel.health == 0:
		curr_vessel.health = floor(curr_vessel.max_health / 2)
	pass_hurt(curr_vessel.health,curr_vessel.max_health)
	if is_para:
		curr_vessel.connect("new_vessel", new_vessel)
		is_parasite = true
	else:
		is_parasite = false
