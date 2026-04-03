extends RoomTransition

func _show_next_room(body: Node2D):
	if body is Vessel and body.is_vessel:
		var other_room: Room # the room on the other side of the door
		# if the body is closer to marker 1 (aka room 1)
		if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
			other_room = room_2 # the other room is room 2
		else: # body closer to room 2
			other_room = room_1 # the other room is room 1
		var hallway = $"../.."
		if !hallway.actors_in_room.has(body):
			other_room = room_1
		# preview the room next door (with 50% opacity)
		other_room.preview_room()

func _hide_next_room(body: Node2D):
	if body is Vessel and body.is_vessel:
		var other_room: Room # the room on the other side of the door
		# if the body is closer to marker 1 (aka room 1)
		if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
			other_room = room_2 # the other room is room 2
		else: # body closer to room 2
			other_room = room_1 # the other room is room 1
		var hallway = $"../.."
		if !hallway.actors_in_room.has(body):
			other_room = room_1
		# hide the room next door
		other_room.hide_room()
