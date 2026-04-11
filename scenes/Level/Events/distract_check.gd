extends Node2D

@export var guard1: Enemy
@export var guard2: Enemy

func _physics_process(_delta):
	if !Global.guards_distracted:
		if guard1 == null or guard1.dead == true:
			if guard2 == null or guard2.dead == true:
				Global.guards_distracted = true
