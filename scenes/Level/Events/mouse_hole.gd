extends WorldEvent

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if curr_vessel is Rat:
		manager.dialog.display_line("You peek into the mousehole, but it's completely empty, save for a few rat droppings.")
		await manager.dialog.finished
	else: # player is NOT a rat
		manager.dialog.display_line("There appears to be a small mousehole at the base of the wall here. You're too big to peek inside.")
		await manager.dialog.finished

	end_event.emit()
