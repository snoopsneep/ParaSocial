extends Area2D

@onready var door = $"../Exterior/Sprite2D/Door"
@onready var interior_bounds = $InteriorBounds
@onready var exterior = $"../Exterior"

# technically just _on_body_exited, but the name used to have a purpose
func trigger(body: Node2D):
	await get_tree().create_timer(0.02).timeout
	if body == null:
		return
	if body is Vessel and body.is_vessel:
		if body in interior_bounds.get_overlapping_bodies():
			get_tree().create_tween().tween_property(exterior, "modulate", Color(1,1,1,0), 0.5)
		else:
			get_tree().create_tween().tween_property(exterior, "modulate", Color(1,1,1,1), 0.5)

func entered(body: Node2D):
	get_tree().create_tween().tween_property(exterior, "modulate", Color(1,1,1,0.5), 0.5)
