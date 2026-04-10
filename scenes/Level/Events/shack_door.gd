extends WorldEvent

@onready var door_visual = $"../Exterior/Sprite2D/Door"
@onready var door_collider = $"../Door/CollisionShape2D"


func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if !Global.guards_distracted:
		if curr_vessel is Nun:
			await manager.dialog.display_line("Hey, you! You can't go in there right now. The groundskeeper is getting some rest.", "Guard:")
			await manager.dialog.display_line("They don't seem like they're going to let me through. Perhaps if they were... distracted?", "")
		else:
			await manager.dialog.display_line("I can't go in until I rid myself of these guards - they'll just follow me otherwise.", "")
	elif door_visual.visible:
		door_visual.visible = false
		door_collider.disabled = true
		await manager.dialog.display_line("The rickety door nearly falls off as you push it open.", "")
	else:
		pass
	end_event.emit()
