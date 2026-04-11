extends WorldEvent

var enabled = true

func trigger():
	if enabled:
		triggered.emit(self)

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	await manager.dialog.display_line("It wouldn't be wise to head back here. Those guards seem to be occupied for now, at least.", "")
	curr_vessel.velocity = Vector2(1,1) * curr_vessel.speed * 3
	end_event.emit()
