extends Node2D

#TODO: revisit this preload after setting up the switching stuff in global/main
#main game scene
var game = preload("res://scenes/main/game.tscn")

func _ready():
	print(Color(0.065, 0.0775, 0.095, 1))

#func load_night(night):
	#$MainMenu.visible = false
	##make the glitch fully visible and animating
	#$Glitch.visible = true
	#$Glitch.speed_scale = 1
	##don't forget to play it
	#$Glitch.play("load_glitch")
	##audio stuff, stop playing menu noise and play a click
	#Audio.sound["FakeoutMenu"].stop()
	#Audio.sound["MenuHover"].volume_db = linear_to_db(1)
	#Audio.sound["MenuHover"].play()
	##make a quick lambda to connect to a signal
	#var hide_glitch = func(): $Glitch.visible = false
	##make the animation hide itself when it finishes
	#$Glitch.animation_finished.connect(hide_glitch)
	##show the new night text (it's always 5 in the fakeout)
	#$NewNightControl/NewNightText.visible = true
	#await get_tree().create_timer(2.6).timeout
	#$Cutscenes.modulate = Color(0,0,0,0)
	#$Cutscenes.visible = true
	#var fade_again = create_tween()
	#fade_again.tween_property($Cutscenes,"modulate",Color(0,0,0,1),1.2)
	#await fade_again.finished
	#$LoadingIcon.visible = true
	#await get_tree().create_timer(2).timeout
	#var new_night = game.instantiate()
	#new_night.night = 4
	##set the based save file
	#Global.level = 4
	#Global.beatgame = true
	#Global.beat6 = true
	#Global.beat7 = true
	#Global.save()
	##this is the actual "change scenes" part. quick and dirty, but works
	#get_tree().root.add_child(new_night)
	#get_node("/root/FakeMenu").free()
#
#func _on_boop_nose_input_event(_viewport, event, _shape_idx,guy:int):
	#if event is InputEventMouseButton:
		#if event.is_pressed():
			#if event.button_index == 1:
				#Audio.sound["BoopNose"].play()
				##fran is id 0, ska is id 1, grob is id 2
				#match guy:
					#0:
						#fran_honks += 1
					#1:
						#ska_honks += 1
					#2:
						#grob_honks += 1


func _on_new_game():
	get_tree().change_scene_to_packed(game)
