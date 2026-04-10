extends Room

## The Z-Index of the room the object is currently in
# (its the same one that the doorway transitions set)
@export var room_z_index: int

# stores references to any nodes behind or in front of the object rn
var behind: Array = []
var in_front: Array = []
var inside: Array = []

@onready var left: Vector2 = $LeftPoint.global_position
@onready var middle: Vector2 = $Middle.global_position
@onready var right: Vector2 = $RightPoint.global_position

func _physics_process(_delta):
	var swapped_this_frame: int = 0

	swapped_this_frame = 0
	for i in range(inside.size()):
		i -= swapped_this_frame
		# if it's not inside anymore
		if !check_overlap(inside[i]) == 0:
			var add_n_remove = inside[i]
			# remove it and add it again (to see if its inside)
			_on_sprite_exited(add_n_remove)
			_on_sprite_overlap(add_n_remove)
			# if it's not inside anymore
			if !inside.has(add_n_remove):
				swapped_this_frame += 1
			else:
				inside[i].get_parent().z_index = 3
				inside[i].get_parent().z_slave = true
				inside[i].get_parent().in_shed = true
		else:
			inside[i].get_parent().z_index = 3
			inside[i].get_parent().z_slave = true
			inside[i].get_parent().in_shed = true

	# make sure everything around it has the correct z-index
	for i in range(in_front.size()):
		i -= swapped_this_frame
		# if it's not in front anymore
		if !check_overlap(in_front[i]) == 2:
			var add_n_remove = in_front[i]
			# remove it and add it again (to see if its in front)
			_on_sprite_exited(add_n_remove)
			_on_sprite_overlap(add_n_remove)
			if !in_front.has(add_n_remove):
				swapped_this_frame += 1
			else:
				in_front[i].get_parent().z_index = 5
				in_front[i].get_parent().z_slave = true
		else:
			in_front[i].get_parent().z_index = 5
			in_front[i].get_parent().z_slave = true

	swapped_this_frame = 0
	for i in range(behind.size()):
		i -= swapped_this_frame
		# if it's not behind anymore
		if !check_overlap(behind[i]) == 1:
			var add_n_remove = behind[i]
			# remove it and add it again (to see if its in front)
			_on_sprite_exited(add_n_remove)
			_on_sprite_overlap(add_n_remove)
			# if it's not in front anymore
			if !behind.has(add_n_remove):
				swapped_this_frame += 1
			else:
				behind[i].get_parent().z_index = 1
				behind[i].get_parent().z_slave = true
		else:
			behind[i].get_parent().z_index = 1
			behind[i].get_parent().z_slave = true

# if 0, inside. if 1, behind. if 2, in front.
func check_overlap(hitbox: Node2D) -> int:
	var pos: Vector2 = hitbox.get_parent().global_position
	# if the actor is above and to the left of the right marker
	if hitbox.get_parent() in $IntoShack/InteriorBounds.get_overlapping_bodies():
		return 0
	elif (pos.y < right.y) and (pos.x < right.x):
		if pos.x > middle.x: # if above right and between right & middle horizontally
			return 1
		# if above mid & to the right of the left marker
		elif (pos.y < middle.y) and (pos.x > left.x):
			return 1
		else:
			return 2
	else:
		return 2

# triggers when an actor's hitbox overlaps with the object
func _on_sprite_overlap(hurtbox):
	# make sure the area is the hurtbox of a vessel (they all have this)
	if hurtbox.name == "Hurtbox":
		# if it's in front of the object
		if check_overlap(hurtbox) == 2:
			# add it to the "in front" list
			in_front.append(hurtbox)
			hurtbox.get_parent().z_index = 5
			hurtbox.get_parent().z_slave = true
		elif check_overlap(hurtbox) == 1:
			# add it to the "behind" list
			behind.append(hurtbox)
			hurtbox.get_parent().z_index = 1
			hurtbox.get_parent().z_slave = true
		else:
			# add it to the "inside" list
			inside.append(hurtbox)
			hurtbox.get_parent().z_index = 3
			hurtbox.get_parent().z_slave = true
			hurtbox.get_parent().in_shed = true

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
	elif inside.has(hurtbox):
		# reset its z_index
		hurtbox.get_parent().z_index = room_z_index
		# erase in from the behind list
		inside.erase(hurtbox)
		# no longer controlling its z index
		hurtbox.get_parent().z_slave = false
		hurtbox.get_parent().in_shed = false
