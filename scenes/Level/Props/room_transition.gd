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
	other_room.actors_in_room.erase(body)
	curr_room.actors_in_room.append(body)
	%Player.curr_room = curr_room
	if (body is Vessel and body.is_vessel):
			# fully reveal the current room
			curr_room.reveal_room()
			# make the room you just left the previewed one
			other_room.preview_room()

func _show_next_room(body: Node2D):
	if body is Vessel and body.is_vessel:
		var other_room: Room # the room on the other side of the door
		# if the body is closer to marker 1 (aka room 1)
		if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
			other_room = room_2 # the other room is room 2
		else: # body closer to room 2
			other_room = room_1 # the other room is room 1
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
		# hide the room next door
		other_room.hide_room()
