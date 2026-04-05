extends WorldEvent

var grave_name: String
var grave_dates: String
var grave_inscription: String

func _ready():
	grave_name = get_parent().grave_name
	grave_dates = get_parent().grave_dates
	grave_inscription = get_parent().grave_inscription

func run_event(manager: EventManager, _curr_vessel: Vessel = null):
	await manager.dialog.display_line(grave_name + "\n" + grave_dates)
	if grave_inscription != "":
		await manager.dialog.display_line(grave_inscription)
	var choice = await manager.dialog.display_choices("Do you want to dig here? (This'll only work if you're the gravedigger later)", ["Yes", "No"])
	if choice == 0: # yes
		print("dug a hole!")
	else:
		print("did NOT dig a hole")
	end_event.emit()
