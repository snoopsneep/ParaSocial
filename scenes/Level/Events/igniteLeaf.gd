extends WorldEvent

@onready var leafpile = %"Leafpile"
@onready var shackman1 = %"Shackman1"
@onready var shackman2 = %"Shackman2"

func run_event(manager: EventManager, curr_vessel: Vessel = null):
	if curr_vessel == Nun:
			leafpile.ignite()
			shackman1.patrol_route[0] = Vector2(11118, 4970)
			shackman2.patrol_route[0] = Vector2(11118, 4970)
	end_event.emit()
