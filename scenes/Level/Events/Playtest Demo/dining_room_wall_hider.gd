extends RoomTransition

# technically just _on_body_exited, but the name used to have a purpose
func trigger(body: Node2D):
	await get_tree().create_timer(0.05).timeout
	if body == null:
		return
	# if the body is closer to marker 1
	if body.global_position.distance_to(marker_1.global_position) < body.global_position.distance_to(marker_2.global_position):
		# hide the main hall
		get_tree().create_tween().tween_property($"../../../Main Hall", "modulate", Color(1,1,1,0), 0.2)
	else: # body closer to marker 2
		# show the main hall
		get_tree().create_tween().tween_property($"../../../Main Hall", "modulate", Color(1,1,1,0.5), 0.2)
