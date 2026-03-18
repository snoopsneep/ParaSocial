extends WorldEvent

func run_event(manager: EventManager):
	if manager.game.player.curr_vessel is Rat:
		if !Global.got_cheese:
			# collecting the cheese
			manager.game.player.curr_vessel.visible = false
			manager.dialog.display_line("You scurry into your hole to check your stash.")
			await manager.dialog.finished
			manager.dialog.display_line("You collected some cheese! It wouldn't make a good meal on its own, but maybe with another ingredient...")
			await manager.dialog.finished
			manager.game.player.curr_vessel.visible = true
			Global.got_cheese = true
		else:
			# cheese already collected
			manager.dialog.display_line("You peek into the mousehole, but it's completely empty, save for the occasional rat droppings.")
			await manager.dialog.finished
	else: # player is NOT a rat
		manager.dialog.display_line("There appears to be a small mousehole at the base of the wall here.")
		await manager.dialog.finished

	end_event.emit()
