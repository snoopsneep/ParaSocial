extends WorldEvent

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if curr_vessel is Nun:
		if Global.food_cooked:
			await manager.dialog.display_line("Here’s some food, sir. I thought you noble men could use it.", 'Sister Margaret:')
			await manager.dialog.display_line("Blimey! How kind of you... That Monarch is too superstitious - a sweet little nun like you wouldn’t harm anyone. Here, I’ll let you go... just don’t tell anybody.", 'Guard Captain:')
			await manager.dialog.display_line("The guard looks around to make sure nobody's watching, and quickly unlocks the back door and lets you out.")
			manager.game_over.puzzle_victory() # show the victory screen
		elif (Global.got_cheese and !Global.used_cheese) or (Global.got_potato and !Global.used_potato):
			# has ingredient, not in pot
			await manager.dialog.display_line("Oh man, that ingredient you've got there almost looks good enough to eat... ", 'Guard Captain:')
			await manager.dialog.display_line("Almost.", 'Guard Captain:')
			await manager.dialog.display_line("Maybe if you cooked it, or somethin\'...", 'Guard Captain:')
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
