extends WorldEvent

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if !Global.got_potato:
		# collecting the cheese
		await manager.dialog.display_line("This guard appears to be eating a whole, raw potato like an apple.")
		var choice = await manager.dialog.display_choices("Ask the guard for some of his potato?", ["Yes", "No"])
		if choice == 0: # yes
			await manager.dialog.display_line("Excuse me, would you mind sharing that potato? I haven’t eaten in ages.", "Sister Margaret:")
			await manager.dialog.display_line("...I guess you can have some...", "Guard:")
			# change guard's sprite
			get_parent().get_child(1).play("DownRight")
			await manager.dialog.display_line("You got a potato!")
			Global.got_potato = true
		else: # no
			end_event.emit()
			return
	else:
		# potato already collected
		await manager.dialog.display_line("What? Don't look at me like that! That's all I had! Honest!", "Guard:")

	end_event.emit()
