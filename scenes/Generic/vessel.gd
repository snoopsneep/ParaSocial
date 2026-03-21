class_name Vessel extends CharacterBody2D
## The abstract Vessel class, to be extended by all other Vessels.

## The vessel's current health.
var health: int

## The vessel's maximum/starting health.
@export var max_health: int

## The vessel's top speed.
@export var speed: float = 400.0

## If [code]true[/code], this is the player's current vessel.
var is_vessel: bool = false

# I think can_vessel might be replaced by the vessel collision layer?
## If [code]true[/code], this is a vessel that can be controlled.
var can_vessel: bool = false

## If [code]true[/code], will be attacked if it's the current vessel.
var is_aggro: bool = true

## Emits when the vessel takes damage. Passes the current and max hp.
signal hurt(hp,max_hp)
## Emits when the vessel kicks the player out.
signal boot

# some variables for making the sprite display nice
var _display_left: bool = false # if true, going left. else, going right
var _display_up: bool = false # if true, going up. else, going down.

func _ready():
	health = max_health

func _physics_process(_delta):
	if !is_vessel:
		$Interactable.visible = false

	$Hurtbox.collision_layer = collision_layer

	# setting the sprite of the vessel based on movement
	if velocity:
		if velocity.x < 0: # moving left
			_display_left = true
		if velocity.x > 0: # moving right
			_display_left = false
		if velocity.y > 0: # moving down
			_display_up = false
		if velocity.y < 0: # moving up
			_display_up = true
		# if the vessel is moving horizontally but NOT vertically, always
		# show the camera-facing sprite.
		if velocity.y == 0.0 and velocity.x != 0.0:
			_display_up = false

		if _display_left:
			if _display_up:
				$Sprite.play("UpLeft")
			else:
				$Sprite.play("DownLeft")
		else: # moving right
			if _display_up:
				$Sprite.play("UpRight")
			else:
				$Sprite.play("DownRight")

## Triggers when the Vessel takes damage.
func hit(dmg = 1):
	health -= dmg
	if health <= 0:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		boot.emit()
	hurt.emit(health,max_health)

## Triggers when the player hits the interact button.
func interact():
	var int_arr: Array = $InteractRange.get_overlapping_areas()
	var interaction: WorldEvent = null
	if int_arr.is_empty():
		return
	for i in int_arr:
		# if there's no interaction or if the current interaction is CLOSER than the one selected
		if interaction == null or (i.position.distance_to(position) < interaction.position.distance_to(position)):
			# if i is an event where self is listed as compatible
			if i is WorldEvent:
				if self.name in i.compatible_vessels:
					if i.compatible_vessels[self.name]:
						interaction = i # select the current interaction
	if interaction == null: return # if there's still no valid interaction, bail
	interaction.trigger()
	velocity = Vector2(0,0)


func _interactables_check(_area):
	if is_vessel:
		$Interactable.visible = false
		if $InteractRange.get_overlapping_areas().size() == 0:
			return
		for i in $InteractRange.get_overlapping_areas():
			if i is WorldEvent:
				if self.name in i.compatible_vessels:
					if i.compatible_vessels[self.name]:
						$Interactable.visible = true
