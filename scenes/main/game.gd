extends Node2D

var projectile: PackedScene = preload("res://scenes/char/enemy_projectile.tscn")
var para_scene: PackedScene = preload("res://scenes/char/parasite.tscn")
var enemy_scene: PackedScene = preload("res://scenes/char/enemy.tscn")
var rat_scene: PackedScene = preload("res://scenes/char/rat.tscn")
@onready var player = $Player

func _physics_process(_delta):
	if Input.is_action_just_pressed("Debug Action 1"): # M
		spawn_enemies()
	if Input.is_action_just_pressed("Debug Action 2"): # ESC or N
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("Debug Action 3"): # B
		spawn_rat()

func enemy_projectile(source,dir,is_evil):
	var new_proj = projectile.instantiate()
	new_proj.position = source
	new_proj.rotation_degrees = rad_to_deg(dir.angle())
	new_proj.direction = dir
	new_proj.is_evil = is_evil
	$Projectiles.add_child(new_proj)

func spawn_parasite(source,velocity):
	var new_para: CharacterBody2D = para_scene.instantiate()
	source.y -= 1.5
	new_para.position = source
	new_para.velocity = velocity
	$Characters.add_child(new_para)
	player.new_vessel(new_para,true)

func spawn_enemies():
	for i in $Map/EnemySpawns.get_children():
		var new_enemy: CharacterBody2D = enemy_scene.instantiate()
		new_enemy.position = i.position
		$Characters.add_child(new_enemy)
		new_enemy.connect("attack", enemy_projectile)

func spawn_rat():
	var new_rat: CharacterBody2D = rat_scene.instantiate()
	new_rat.position = $Map/EnemySpawns/Enemy1.position
	$Characters.add_child(new_rat)

func _on_update_hp(hp,max_hp):
	$CanvasLayer/UI/Label.text = str(hp) + "/" + str(max_hp) + " HP"
