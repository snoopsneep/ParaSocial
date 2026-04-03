extends RoomTransition

# room 1 is outside, room 2 is inside

# technically just _on_body_exited, but the name used to have a purpose
func trigger(body: Node2D):
	await get_tree().create_timer(0.02).timeout
	if body == null:
		return
	var curr_room: Room # the room the body is entering
	var other_room: Room # the room the body is leaving
	# if the body is closer to marker 1 (aka outside)
	if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
		curr_room = room_1
		other_room = room_2
		body.z_index = 1
	else: # body closer to room 2 (aka inside)
		curr_room = room_2
		other_room = room_1
		body.z_index = 0

	other_room.actors_in_room.erase(body)
	curr_room.actors_in_room.append(body)

func _show_next_room(body: Node2D):
	if $"../../Graphics/SHACK/Door".visible == false:
		if body is Vessel and body.is_vessel:
			room_1.preview_room()


func _hide_next_room(body: Node2D):
	var curr_room: Room # the room the body is entering
	# if the body is closer to marker 1 (aka outside)
	if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
		curr_room = room_1
	else: # body closer to room 2 (aka inside)
		curr_room = room_2

	if $"../../Graphics/SHACK/Door".visible == false:
		if body is Vessel and body.is_vessel:
			# closer to outside
			if curr_room == room_1:
				room_1.reveal_room()
			else: # body closer to room 2
				room_1.hide_room()
