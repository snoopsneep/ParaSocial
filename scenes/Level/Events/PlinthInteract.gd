extends WorldEvent

func run_event(_manager: EventManager, _curr_vessel: Vessel = null):
	end_event.emit()
