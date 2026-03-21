extends WorldEvent

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	var everyone_dead = true
	for i in get_tree().get_nodes_in_group("Enemies"): # check all enemies
		if i.name == "HungryLeader" or i.dead:
			pass
		else: # if you find one that isn't dead
			everyone_dead = false # not everyone is dead
	if everyone_dead:
		get_tree().paused = true
		await manager.dialog.display_line("With all of the guards taken care of, you gently push open the front doors of the church...")
		end_event.emit()
		manager.game_over.combat_victory()
	else:
		# only do the default lines as the nun (so the statue can't interact in combat)
		if curr_vessel is Nun:
			await manager.dialog.display_line("The front doors of the church are massive, even for the statue.")
			await manager.dialog.display_line("This would certainly work as a way out, but those guards won't let you leave.")
			await manager.dialog.display_line("Maybe if they weren't around...")
	end_event.emit()
