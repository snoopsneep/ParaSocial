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

## Handy reference variable pointing to the EventManager.
@onready var event_manager = $EventManager

func _ready():
	#region set up room debug values
	$Map/Kitchen.modulate = Color(1,1,1,0)
	$Map/Kitchen.visible = true
	$"Map/Dining Room".modulate = Color(1,1,1,0)
	$"Map/Dining Room".visible = true
	$"Map/Main Hall".modulate = Color(1,1,1,0)
	$"Map/Main Hall".visible = true
	$Map/Hallway.modulate = Color(1,1,1,0.5)
	$Map/Hallway.visible = true
	$Map/Chapel.modulate = Color(1,1,1,1)
	$Map/Chapel.visible = true
	#endregion

	#region reset global progress flags
	Global.got_potato = false
	Global.used_potato = false
	Global.got_cheese = false
	Global.used_cheese = false
	Global.lit_pot = false
	Global.food_cooked = false
	#endregion

	# set up event triggers
	for i in get_tree().get_nodes_in_group("Events"):
		i.triggered.connect(start_event)
		i.end_event.connect(end_event)

# Runs once every physics frame (so it runs at 60fps no matter what the player's actual
# fps is. might lag the game - i don't actually know the difference between
# _process and _physics_process is, truthfully) -Ian
func _physics_process(_delta):
	# TEMP: press escape to reload game, just for playtest
	if Input.is_action_just_pressed("Pause"):
		get_tree().reload_current_scene()

## Spawns a new parasite at location [param source] with z_index [param z_ind].
##
## Made to connect to signals like [signal Player.parasite].
func spawn_parasite(source, z_ind):
	var new_para: CharacterBody2D = para_scene.instantiate()
	source.y -= 10
	new_para.position = source
	new_para.z_index = z_ind
	$Characters.call_deferred("add_child", new_para)
	player.new_vessel(new_para,true)

func start_event(event: WorldEvent):
	Global.player_disabled = true # TODO: make this optional! with a parameter!!
	event.run_event(event_manager, player.curr_vessel)

func end_event():
	# stall a lil so the player doesn't instantly attack when they progress
	# the dialog
	await get_tree().create_timer(0.15).timeout
	Global.player_disabled = false

# recieves signals to update the hp display, and then does that.
func _on_update_hp(hp,max_hp):
	$"UI Layer/UI/Label".text = str(hp) + "/" + str(max_hp) + " HP"
