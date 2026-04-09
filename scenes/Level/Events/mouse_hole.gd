extends WorldEvent

@export var pages: Array[Page]

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if curr_vessel is Rat:
		curr_vessel.visible = false
		await manager.dialog.display_line("Scurrying into the hole, you find a small hollow that appears to be serving as the nest for this rat.")
		var choice = await manager.dialog.display_choices("Among the food scraps and rat droppings, lies a small note, its edges slightly nibbled. Would you like to read it?", ["Yes", "No"])
		if choice == 0: # yes
			await manager.dialog.show_note(pages[0])
			if pages.size() > 1:
				for i in range(1,pages.size()):
					await manager.dialog.flip_note(pages[i])
			manager.dialog.hide_note()
		curr_vessel.visible = false
	else: # player is NOT a rat
		manager.dialog.display_line("There appears to be a small mousehole at the base of the wall here. However, you're too big to investigate further.")
		await manager.dialog.finished
	end_event.emit()
