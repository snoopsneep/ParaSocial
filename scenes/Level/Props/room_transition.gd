class_name RoomTransition extends Area2D

@export var room_1: Room
@export var room_2: Room
@onready var marker_1 = $Marker2D
@onready var marker_2 = $Marker2D2

# technically just _on_body_exited, but the name used to have a purpose
func trigger(body: Node2D):
	await get_tree().create_timer(0.02).timeout
	if body == null:
		return
	var curr_room: Room # the room the body is entering
	var other_room: Room # the room the body is leaving
	# if the body is closer to marker 1 (aka room 1)
	if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
		curr_room = room_1
		other_room = room_2
	else: # body closer to room 2
		curr_room = room_2
		other_room = room_1

	body.z_index = curr_room.z_index
	if body is Vessel:
		if body.is_vessel:
				# reveal the current room (and the rooms around it)
				# this also fades the previous room out naturally!
				curr_room.reveal_room()
				# hide all the rooms connected to the one we're NOT in
				for i in other_room.connected_rooms:
					if i != curr_room: # besides the current room, of course
						get_tree().create_tween().tween_property(i, "modulate", Color(1,1,1,0), 0.5)
