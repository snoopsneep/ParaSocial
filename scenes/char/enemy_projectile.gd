extends RigidBody2D

var direction
var is_evil

@export var speed: float = 300.0

func _ready():
	if is_evil:
		set_collision_mask_value(1,true)
	else:
		set_collision_mask_value(2,true)

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision != null:
		var body = collision.get_collider()
		if "hit" in body:
			body.hit()
		queue_free()

func _on_life_timer_timeout():
	queue_free()
