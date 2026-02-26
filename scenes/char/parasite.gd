extends CharacterBody2D

var health: int = 2
@export var max_health: int = 2
var speed: float = 250
var is_vessel = true
var can_vessel: bool = true
var is_aggro: bool = true
@onready var sight = $Sight
@onready var death_timer = $"Death Timer"
@onready var warning = $Warning
signal hurt(hp,max_hp)
signal new_vessel(body)
signal boot

func _physics_process(_delta):
	if ((1 < death_timer.time_left) && (death_timer.time_left < 1.75)) && !warning.visible:
		warning.visible = true

func hit():
	health -= 1
	if health == 0:
		_on_death()
	hurt.emit(health,max_health)

func possess():
	if sight.has_overlapping_bodies():
		var closest_body
		var closest_dist: float = 9999999.0
		for i in sight.get_overlapping_bodies():
			if (position.distance_to(i.position) < closest_dist):
				closest_dist = position.distance_to(i.position)
				closest_body = i
		new_vessel.emit(closest_body)
		queue_free()

func _on_death():
	$Sprite2D.visible = false
	warning.visible = false
	$CollisionShape2D.disabled = true
	speed = 0
	death_timer.stop()
