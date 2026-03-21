extends WorldEvent

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	await manager.dialog.display_line("This looks like a way out! You try the door...")
	await manager.dialog.display_line("...but it's locked. What kind of back door locks from the outside?")
	await manager.dialog.display_line("That looks like the captain of the guard over there. Maybe he has the key?")
	end_event.emit()
