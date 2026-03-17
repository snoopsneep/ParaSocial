class_name Room extends Node2D

@export var connected_rooms: Array[Node2D]

func reveal_room():
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	for i in connected_rooms:
		get_tree().create_tween().tween_property(i, "modulate", Color(1,1,1,0.5), 0.5)
