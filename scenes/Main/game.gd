class_name Game extends Node2D
## The "main" scene - PLACEHOLDER
##
## The "main game" scene - should probably be split into an abstract "Level" scene
## and then two individual scenes that inherit "Level".

## PackedScene of the enemy's projectile scene, so the game can generate them at runtime.
var projectile: PackedScene = preload("res://scenes/Characters/Guard/enemy_projectile.tscn")

## PackedScene of the parasite scene, so the game can spawn them at runtime.
var para_scene: PackedScene = preload("res://scenes/Characters/Parasite/parasite.tscn")

## Reference to the player's current room
@export var curr_room: Node2D

## Handy reference variable pointing to the player scene.
@onready var player: Player = $Player

func _ready():
	#region set up room debug values
	$Map/Kitchen.modulate = Color(1,1,1,0)
	$Map/Kitchen.visible = true
	$"Map/Dining Room".modulate = Color(1,1,1,0.5)
	$"Map/Dining Room".visible = true
	$"Map/Main Hall".modulate = Color(1,1,1,1)
	$"Map/Main Hall".visible = true
	$Map/Hallway.modulate = Color(1,1,1,0.5)
	$Map/Hallway.visible = true
	$Map/Chapel.modulate = Color(1,1,1,0)
	$Map/Chapel.visible = true
	for i in $Characters.get_children():
		if i.name == "Captain":
			i.z_index = 2
		else:
			i.z_index = 3
	#endregion

	# set up event triggers
	for i in get_tree().get_nodes_in_group("Events"):
		i.triggered.connect(start_event)
		i.end_event.connect(end_event)

# Runs once every physics frame (so it runs at 60fps no matter what the player's actual
# fps is. might lag the game - i don't actually know the difference between
# _process and _physics_process is, truthfully) -Ian
func _physics_process(_delta):
	if Input.is_action_just_pressed("Debug Action 1"):
		get_tree().reload_current_scene()

## Creates a new projectile starting from [param source], heading in direction [param dir],
## and damages the player if [member if_evil] is [code]true[/code].
##
## Made to connect to signals.
func enemy_projectile(source,dir,is_evil):
	var new_proj = projectile.instantiate()
	new_proj.position = source
	new_proj.rotation_degrees = rad_to_deg(dir.angle())
	new_proj.direction = dir
	new_proj.is_evil = is_evil
	$Projectiles.add_child(new_proj)

## Spawns a new parasite at location [param source].
##
## Made to connect to signals like [signal Player.parasite].
func spawn_parasite(source):
	var new_para: CharacterBody2D = para_scene.instantiate()
	source.y -= 1.5
	new_para.position = source
	$Characters.add_child(new_para)
	player.new_vessel(new_para,true)

func start_event(event: WorldEvent):
	if event is WorldTeleport:
		$Player.curr_vessel.position = event.destination
	Global.player_disabled = true # TODO: make this optional! with a parameter!!
	event.run_event($EventManager)

func end_event():
	Global.player_disabled = false

# recieves signals to update the hp display, and then does that.
func _on_update_hp(hp,max_hp):
	$"UI Layer/UI/Label".text = str(hp) + "/" + str(max_hp) + " HP"
