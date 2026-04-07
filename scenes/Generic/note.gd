class_name Note extends WorldEvent

@export var pages: Array[Page]

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	var dialog: Dialog = manager.dialog # makes my life easy
	var choice = await dialog.display_choices("There's a hand-written note sitting here. Would you like to read it?", ["Yes", "No"])
	if choice == 0: # yes
		await dialog.show_note(pages[0])
		if pages.size() > 1:
			for i in range(1,pages.size()):
				await dialog.flip_note(pages[i])
		dialog.hide_note()
	end_event.emit()
