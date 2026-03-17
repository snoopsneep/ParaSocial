extends Node2D

#TODO: revisit this preload after setting up the switching stuff in global/main
#main game scene
var game = preload("res://scenes/Main/game.tscn")

func _ready():
	print(Color(0.065, 0.0775, 0.095, 1))

func _on_new_game():
	get_tree().change_scene_to_packed(game)
