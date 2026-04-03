extends WorldEvent

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	if !get_parent().is_aggro:
		var rand_num = randi_range(1,4)
		match rand_num:
			1:
				manager.dialog.display_line('The Monarch will be here soon, you’ll just have to wait here till then.', 'Guard:')
			2:
				manager.dialog.display_line('Heard there’s something weird going on in this church.. We can’t let you out til\' we have the Monarch’s orders.', 'Guard:')
			3:
				manager.dialog.display_line('Stay back, lady. We’re on orders to lock this place down until the Monarch gets here.', 'Guard:')
			4:
				manager.dialog.display_line('Something’s off about this place… You’re not leaving till the Monarch figures it out.', 'Guard:')
		await manager.dialog.finished
		end_event.emit()
