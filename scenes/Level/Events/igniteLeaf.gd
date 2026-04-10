extends WorldEvent

var ignited: bool = false

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if Global.guards_distracted and !ignited:
		await manager.dialog.display_line("A large, dry pile of leaves. I have no use for these.")
	if ignited:
		await manager.dialog.display_line("You should probably leave before somebody catches you here.")
	else:
		if curr_vessel is not Nun:
			await manager.dialog.display_line("A large, dry pile of leaves. They crunch under your feet with every step.")
			await manager.dialog.display_line("There's a craving somewhere deep within your being to see them reduced to ash at your hand.")
		if curr_vessel is Nun:
			await manager.dialog.display_line("A large, dry pile of leaves. They crunch under your feet with every step.")
			await manager.dialog.display_line("You stare at the incredibly flammable pile of leaves, before your eyes begin to drift down to the candle in your hand.")
			var choice = await manager.dialog.display_choices("Would you like to watch the world burn?", ["Yes", "No"])
			if choice == 0: # yes
				await manager.dialog.display_line("You hold the flame close to the pile, watching as the embers dance across the first few leaves. Before you know it...")
				get_parent().ignite()
				ignited = true
				#region debug
				Global.guards_distracted = true
				#endregion
				await manager.dialog.display_line("The pile erupts in flames! You'd better get out of here while you can...")
			else: # no
				await manager.dialog.display_line("You contain your urges, and leave the pile as it is.")
	end_event.emit()
