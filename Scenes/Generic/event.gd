class_name Event extends Area2D
## Generic Event node to extend when building in-world interactions with props and/or NPCs.

## Dictates how the Event will be triggered.
##
## "Interactable" requires the player to interact with the area to trigger the event.
##
## "Proximity" means the player has to walk over the area to trigger the event.
@export_enum("Interactable", "Proximity") var trigger_type: int = 0

@export var one_shot: bool = false

## Emits when the event is triggered.
signal triggered(this_event: Event)

## Emits when the event is completely over.
signal end_event

func _ready():
	if trigger_type == 1: # if trigger_type is "Proximity"
		body_entered.connect(trigger) # trigger when the player walks here

## Emits the [signal triggered] signal, which tells the [Game] node to do event things.
##
## Override to have something different happen when the player interacts with the event.
func trigger():
	if one_shot:
		monitoring = false # disable upon triggering (can't be triggered again)
	triggered.emit(self)

## Contains the actual scripting of the event. Is called from [Game] after verifying that it's valid
##
## Override to implement the event. If not overridden, will push an error that says "Invalid event!"
func run_event(manager: EventManager):
	push_warning("Invalid event!")
	end_event.emit()
