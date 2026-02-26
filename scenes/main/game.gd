class_name Game extends Node2D
## The "main" scene - PLACEHOLDER
##
## The "main game" scene - should probably be split into an abstract "Level" scene
## and then two individual scenes that inherit "Level".

# TODO: we need some kind of level switcher/manager. this might be more of
# a Global problem, though.

## PackedScene of the enemy's projectile scene, so the game can generate them at runtime.
var projectile: PackedScene = preload("res://scenes/char/enemy_projectile.tscn")

## PackedScene of the parasite scene, so the game can spawn them at runtime.
var para_scene: PackedScene = preload("res://scenes/char/parasite.tscn")

## PackedScene of the enemy scene, so the game can spawn them at runtime.
var enemy_scene: PackedScene = preload("res://scenes/char/enemy.tscn")

## PackedScene of the rat scene, so the game can spawn them at runtime.
var rat_scene: PackedScene = preload("res://scenes/char/rat.tscn")

## Handy reference variable pointing to the player scene.
@onready var player: Player = $Player

# Runs once every physics frame (so it runs at 60fps no matter what the player's actual
# fps is. might lag the game - i don't actually know the difference between
# _process and _physics_process is, truthfully -Ian
func _physics_process(_delta):
	# this is just the debug inputs from milestone 1. these can be deleted
	# along with the EnemySpawns node & its children
	if Input.is_action_just_pressed("Debug Action 1"): # M
		spawn_enemies()
	if Input.is_action_just_pressed("Debug Action 2"): # ESC or N
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("Debug Action 3"): # B
		spawn_rat()

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

## Spawns enemies at the points under the EnemySpawns node.
##
## Made for the Milestone 1 presentation, can be deleted.
func spawn_enemies():
	for i in $Map/EnemySpawns.get_children():
		var new_enemy: CharacterBody2D = enemy_scene.instantiate()
		new_enemy.position = i.position
		$Characters.add_child(new_enemy)
		new_enemy.connect("attack", enemy_projectile)

## Spawns a rat at one of the points under the EnemySpawns node.
##
## Made for the Milestone 1 presentation, can be deleted.
func spawn_rat():
	var new_rat: CharacterBody2D = rat_scene.instantiate()
	new_rat.position = $Map/EnemySpawns/Enemy1.position
	$Characters.add_child(new_rat)

# recieves signals to update the hp display, and then does that.
func _on_update_hp(hp,max_hp):
	$CanvasLayer/UI/Label.text = str(hp) + "/" + str(max_hp) + " HP"
