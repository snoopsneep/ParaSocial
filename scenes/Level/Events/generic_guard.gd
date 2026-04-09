extends WorldEvent

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	var rand_num = randi_range(1,3)
	match rand_num:
		1:
			manager.dialog.display_line('Stay back, lady. We’re on high alert for grave robbers and we don’t need you getting in the way.', 'Guard:')
		2:
			manager.dialog.display_line('Sorry, Miss, but you’ve gotta leave us alone... We need to stay focused, and this is no time for small talk.', 'Guard:')
		3:
			manager.dialog.display_line('Do you have any suspicious activity to report? If not, get lost... We’re trying to do our jobs.', 'Guard:')
	await manager.dialog.finished
	end_event.emit()
