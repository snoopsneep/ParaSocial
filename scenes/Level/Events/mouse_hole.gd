extends WorldEvent

@export var pages: Array[Page]

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if curr_vessel is Rat:
		var choice = await manager.dialog.display_choices("There's a hand-written note sitting here. Would you like to read it?", ["Yes", "No"])
		if choice == 0: # yes
			await manager.dialog.show_note(pages[0])
			if pages.size() > 1:
				for i in range(1,pages.size()):
					await manager.dialog.flip_note(pages[i])
			manager.dialog.hide_note()
	else: # player is NOT a rat
		manager.dialog.display_line("There appears to be a small mousehole at the base of the wall here. You're too big to peek inside.")
		await manager.dialog.finished

	end_event.emit()
