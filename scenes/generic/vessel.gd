class_name Vessel extends CharacterBody2D
## The abstract Vessel class, to be extended by all other Vessels.

## The vessel's current health.
var health: int

## The vessel's maximum/starting health.
@export var max_health: int

## If [code]true[/code], this is the player's current vessel.
var is_vessel: bool = false

# I think can_vessel might be replaced by the vessel collision layer?
## If [code]true[/code], this is a vessel that can be controlled.
var can_vessel: bool = false

## If [code]true[/code], will be attacked if it's the current vessel.
var is_aggro: bool = true

## The player's current speed.
var speed: float

## Emits when the vessel takes damage. Passes the current and max hp.
signal hurt(hp,max_hp)
## Emits when the vessel kicks the player out.
signal boot

func hit():
	health -= 1
	if health == 0:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		boot.emit()
	hurt.emit(health,max_health)
