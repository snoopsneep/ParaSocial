extends WorldEvent

@export var destination_room: Room
@export var destination: Vector2
@export var nun_destination: Vector2
@export var nun: Nun

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	await manager.dialog.display_line("The back door of the church. It leads out to the graveyard out back.")
	var choice = await manager.dialog.display_choices("Would you like to go outside?", ["Yes", "No"])
	if choice == 0: # yes
		manager.game_over.to_black("","",false)
		manager.fade_track_out(true)
		manager.fade_track_in(false)
		await manager.game_over.done_fading
		if curr_vessel is not Nun: # if you're not the nun, move her too
			nun.global_position = nun_destination
			nun.sprite.play("UpLeft")
			nun.z_index = destination_room.z_index
			get_parent().get_parent().actors_in_room.erase(nun)
			destination_room.actors_in_room.append(nun)
			nun.modulate = Color(1,1,1,1)
		curr_vessel.global_position = destination
		curr_vessel.sprite.play("DownLeft")
		curr_vessel.z_index = destination_room.z_index
		get_parent().get_parent().actors_in_room.erase(curr_vessel)
		destination_room.actors_in_room.append(curr_vessel)
		var player = manager.game.player
		player.global_position = curr_vessel.global_position
		player.find_child("GameCamera").zoom = Vector2(0.5,0.5)
		manager.door_sound.play()
		manager.game_over.fade_in()
		end_event.emit()
	else:
		end_event.emit()
