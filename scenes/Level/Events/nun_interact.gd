extends WorldEvent

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	var rand_num = randi_range(1,4)
	if !Global.mausoleum_visited:
		match rand_num:
			1:
				manager.dialog.display_line('We must save that poor man in the mausoleum.', 'Sister Margaret:')
			2:
				manager.dialog.display_line('The mausoleum is in the graveyard behind the church, my Goddess.', 'Sister Margaret:')
			3:
				manager.dialog.display_line('I believe the mausoleum is locked. The groundskeeper may be able to help us open it.', 'Sister Margaret:')
			4:
				manager.dialog.display_line('May this candle be your guiding light, my Goddess, as your grace has been to me.', 'Sister Margaret:')
	else: # already visited mausoleum
		match rand_num:
			1:
				manager.dialog.display_line('I haven’t seen the priest in so long... Faustine, please don’t tell me he’s given up on you!', 'Sister Margaret:')
			2 or 4:
				manager.dialog.display_line('I’m so grateful we were able to feed that poor man... I look forward to saving many others with you, my Goddess.', 'Sister Margaret:')
			3:
				manager.dialog.display_line('Do you intend to save any others, Faustine?', 'Sister Margaret:')
	await manager.dialog.finished
	end_event.emit()
