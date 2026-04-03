extends WorldEvent

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	await manager.dialog.display_line("There's a pot sitting on the stove, patiently waiting to be used.")
	await manager.dialog.display_line("...It's going to be waiting here for a while.")
	end_event.emit()
