class_name Room extends Node2D

@export var connected_rooms: Array[Node2D]
@export var actors_in_room: Array[Node2D]

func _ready():
	for i in actors_in_room:
		i.z_index = z_index

func reveal_room():
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	for i in actors_in_room:
		get_tree().create_tween().tween_property(i, "modulate", Color(1,1,1,1), 0.5)

func preview_room():
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,0.5), 0.5)
	for i in actors_in_room:
		get_tree().create_tween().tween_property(i, "modulate", Color(1,1,1,0.5), 0.5)

func hide_room():
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,0), 0.5)
	for i in actors_in_room:
		get_tree().create_tween().tween_property(i, "modulate", Color(1,1,1,0), 0.5)
