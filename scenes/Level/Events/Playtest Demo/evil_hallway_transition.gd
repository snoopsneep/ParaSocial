extends RoomTransition

@export var player: Node2D

func _ready():
	trigger(get_child(1), true)

# the collision in the main room/hallway was being a huge bitch
# which is why "first_run" exists. it's only used in _ready() above
func trigger(body: Node2D, first_run: bool = false):
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
	if (body is Vessel and body.is_vessel) or first_run:
		if !first_run:
				# fully reveal the current room
				curr_room.reveal_room()
				# make the room you just left the previewed one
				other_room.preview_room()

		if curr_room == room_1: # hallway
			$"../../Colliders/TopRightWall1".process_mode = Node.PROCESS_MODE_DISABLED
			$"../../Colliders/TopRightWall1Point5".process_mode = Node.PROCESS_MODE_DISABLED
			$"../../Colliders/TopRightWall2".process_mode = Node.PROCESS_MODE_DISABLED
			$"../../Colliders/TopRightWall3".process_mode = Node.PROCESS_MODE_DISABLED
			$"../../../Hallway/Colliders/BottomLeftWall".process_mode = Node.PROCESS_MODE_ALWAYS
			$"../../../Hallway/Colliders/BottomLeftWall2".process_mode = Node.PROCESS_MODE_ALWAYS
			$"../../../Hallway/Colliders/TopLeftWall".process_mode = Node.PROCESS_MODE_ALWAYS
		else: # main hall
			$"../../Colliders/TopRightWall1".process_mode = Node.PROCESS_MODE_ALWAYS
			$"../../Colliders/TopRightWall1Point5".process_mode = Node.PROCESS_MODE_ALWAYS
			$"../../Colliders/TopRightWall2".process_mode = Node.PROCESS_MODE_ALWAYS
			$"../../Colliders/TopRightWall3".process_mode = Node.PROCESS_MODE_ALWAYS
			$"../../../Hallway/Colliders/BottomLeftWall".process_mode = Node.PROCESS_MODE_DISABLED
			$"../../../Hallway/Colliders/BottomLeftWall2".process_mode = Node.PROCESS_MODE_DISABLED
			$"../../../Hallway/Colliders/TopLeftWall".process_mode = Node.PROCESS_MODE_DISABLED
