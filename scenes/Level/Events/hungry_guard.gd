extends WorldEvent

func run_event(manager: EventManager):
	manager.dialog.display_line('The guard in front of you is braced against the wall, panting.')
	await manager.dialog.finished
	manager.dialog.display_line('He barely even notices as you approach.')
	await manager.dialog.finished
	manager.dialog.display_line('\"Oi, ain\'t you one of them nuns?\"',"Guard Captain:")
	await manager.dialog.finished
	manager.dialog.display_line('\"Couldja find me somefin\' to eat around here? I\'m starvin\' half to death!\"',"Guard Captain:")
	await manager.dialog.finished
	manager.dialog.display_line('\"I\'ll take anything but more rations, I swear!\"',"Guard Captain:")
	await manager.dialog.finished
	end_event.emit()
