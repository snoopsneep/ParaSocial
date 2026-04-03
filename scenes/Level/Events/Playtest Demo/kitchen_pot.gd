extends WorldEvent

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	if !Global.lit_pot: # if the pot isn't lit yet
		await manager.dialog.display_line("There's a pot sitting on the stove. Perhaps you could cook something in it...")
		var choice = await manager.dialog.display_choices("Light the stove?", ["Yes", "No"])
		if choice == 0: # Yes
			$"../../Graphics/Floor + Walls/LitUp".visible = true
			Global.lit_pot = true
			await manager.dialog.display_line("Perfect! Now to find some ingredients...")
			await manager.dialog.display_line("There don't seem to be any in here (despite this being a kitchen), maybe you should look around the church?")
		else: # No
			end_event.emit()
			return
	elif Global.used_cheese and Global.used_potato and !Global.food_cooked:
		# cooking the shit
		await manager.dialog.display_line("You place a lid gently on the pot, and wait a little while.")
		await manager.dialog.display_line("You're not entirely sure what you're cooking (or even, really, how to cook at all), but it doesn't seem to be burning?")
		await manager.dialog.display_line("Taking the lid off of the pot, you gently pour what you've made onto a plate. It almost looks like a baked potato, although you don't think baking usually happens in a pot.")
		await manager.dialog.display_line("Nevertheless, it'll probably be good enough for somebody who's REALLY hungry. These days, that's almost everybody.")
		await manager.dialog.display_line("Before you go, you place the pot back on the stove, and turn it off. That could be a fire hazard!")
		$"../../Graphics/Floor + Walls/LitUp".visible = false
		Global.food_cooked = true
	elif Global.got_cheese and !Global.used_cheese: # adding the cheese
		var choice = await manager.dialog.display_choices("Would you like to add the cheese to the pot?", ["Yes", "No"])
		if choice == 0: # Yes
			Global.used_cheese = true
			await manager.dialog.display_line("You drop the cheese into the pot with a quiet \"plop\".")
			if Global.used_potato:
				await manager.dialog.display_line("That must be everything you need! Time to finish the dish.")
			else:
				await manager.dialog.display_line("Maybe you could find something else to put in here...")
		else: # No
			end_event.emit()
			return
	elif Global.got_potato and !Global.used_potato: # adding the potato
		var choice = await manager.dialog.display_choices("Would you like to add the potato to the pot?", ["Yes", "No"])
		if choice == 0: # Yes
			Global.used_potato = true
			$"../../Graphics/Floor + Walls/LitUp".visible = true
			await manager.dialog.display_line("You drop the potato into the pot with a quiet \"plop\".")
			if Global.used_cheese:
				await manager.dialog.display_line("That must be everything you need! Time to finish the dish.")
			else:
				await manager.dialog.display_line("Maybe you could find something else to put in here...")
		else: # No
			end_event.emit()
			return
	elif Global.food_cooked: # food already cooked
		await manager.dialog.display_line("The dirty pot sits in the darkness; left alone after fulfilling its duty.")
	else: # pot on, no ingredients in hand
		await manager.dialog.display_line("The pot sits quietly, waiting for you to finish your masterpiece.")

	end_event.emit()
