extends WorldEvent

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	var rand_num = randi_range(1,4)
	match rand_num:
		1:
			manager.dialog.display_line('I will follow you to the ends of the earth, my Goddess.', 'Sister Margaret:')
		2:
			manager.dialog.display_line('The graveyard is full of The Duke\'s guards. Be careful out there.', 'Sister Margaret:')
		3:
			manager.dialog.display_line('Whatever can I do for you, my Goddess?', 'Sister Margaret:')
		4:
			manager.dialog.display_line('Whatever I have, I give unto you, my Goddess. I am merely a vessel for your will.', 'Sister Margaret:')
	await manager.dialog.finished
	end_event.emit()
