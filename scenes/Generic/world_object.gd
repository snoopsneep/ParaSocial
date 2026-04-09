class_name WorldObject extends StaticBody2D

## The Z-Index of the room the object is currently in
# (its the same one that the doorway transitions set)
@export var room_z_index: int

# stores references to any nodes behind or in front of the object rn
var behind: Array = []
var in_front: Array = []

func _ready():
	z_index = room_z_index

func _physics_process(_delta):
	var swapped_this_frame: int = 0

	# make sure everything around it has the correct z-index
	for i in range(in_front.size()):
		i -= swapped_this_frame
		# if it's not in front anymore
		if check_overlap(in_front[i]):
			var add_n_remove = in_front[i]
			# remove it and add it again (to see if its in front)
			_on_sprite_exited(add_n_remove)
			_on_sprite_overlap(add_n_remove)
			if !in_front.has(add_n_remove):
				swapped_this_frame += 1
			else:
				in_front[i].get_parent().z_index = z_index - 1
				in_front[i].get_parent().z_slave = true
		else:
			in_front[i].get_parent().z_index = z_index + 1
			in_front[i].get_parent().z_slave = true

	swapped_this_frame = 0
	for i in range(behind.size()):
		i -= swapped_this_frame
		# if it's not behind anymore
		if !check_overlap(behind[i]):
			var add_n_remove = behind[i]
			# remove it and add it again (to see if its in front)
			_on_sprite_exited(add_n_remove)
			_on_sprite_overlap(add_n_remove)
			# if it's not in front anymore
			if !behind.has(add_n_remove):
				swapped_this_frame += 1
			else:
				behind[i].get_parent().z_index = z_index - 1
				behind[i].get_parent().z_slave = true
		else:
			behind[i].get_parent().z_index = z_index - 1
			behind[i].get_parent().z_slave = true


# if true, actor is behind object
# (basic y sort)
func check_overlap(hitbox: Node2D) -> bool:
	var pos: Vector2 = hitbox.get_parent().global_position
	if position.y < pos.y: # if the actor is behind
		return true
	else: # if the actor is in front
		return false

# triggers when an actor's hitbox overlaps with the object
func _on_sprite_overlap(hurtbox):
	# make sure the area is the hurtbox of a vessel (they all have this)
	if hurtbox.name == "Hurtbox":
		# if it's in front of the object
		if !check_overlap(hurtbox):
			# add it to the "in front" list
			in_front.append(hurtbox)
			hurtbox.get_parent().z_index = z_index + 1
			hurtbox.get_parent().z_slave = true
		else:
			# add it to the "behind" list
			behind.append(hurtbox)
			hurtbox.get_parent().z_index = z_index - 1
			hurtbox.get_parent().z_slave = true

# when a sprite stops overlapping the object
func _on_sprite_exited(hurtbox):
	# if the sprite was in front
	if in_front.has(hurtbox):
		# reset its z_index
		hurtbox.get_parent().z_index = room_z_index
		# erase in from the in front list
		in_front.erase(hurtbox)
		# no longer controlling its z index
		hurtbox.get_parent().z_slave = false
	# if the sprite was behind instead
	elif behind.has(hurtbox):
		# reset its z_index
		hurtbox.get_parent().z_index = room_z_index
		# erase in from the behind list
		behind.erase(hurtbox)
		# no longer controlling its z index
		hurtbox.get_parent().z_slave = false
