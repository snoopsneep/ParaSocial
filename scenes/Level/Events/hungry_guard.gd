extends WorldEvent

func run_event(manager: EventManager):
	if Global.food_cooked:
		# TODO: quest done - puzzle ending cutscene
		pass
	elif (Global.got_cheese and !Global.used_cheese) or (Global.got_potato and !Global.used_potato):
		# has ingredient, not in pot
		manager.dialog.display_line("Oh man, that ingredient you've got there almost looks good enough to eat... ")
		await manager.dialog.finished
		manager.dialog.display_line("Almost.")
		await manager.dialog.finished
	else:
		# default
		var rand_num = randi_range(1,3) # can be 1, 2, or 3
		match rand_num:
			1:
				manager.dialog.display_line('I’m so hungry… It’s been forever since I had a decent meal.', 'Guard Captain:')
			2:
				manager.dialog.display_line('I would kill for some good food right now. Our rations have been pitiful lately. All thanks to that cheap, gluttonous Monarch.', 'Guard Captain:')
			3:
				manager.dialog.display_line('That damn Monarch gets to eat all they want, while we’re left with scraps. I haven’t felt full in ages.', 'Guard Captain:')
		await manager.dialog.finished
		end_event.emit()
