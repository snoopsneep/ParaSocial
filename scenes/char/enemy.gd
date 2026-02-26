extends CharacterBody2D

@onready var atk_cooldown = $"Attack Cooldown"
@onready var dmg_cooldown = $"Damage Cooldown"
@onready var death_timer = $"Death Timer"
@onready var warning = $Warning

var target: Node2D
var health: int = 5
@export var max_health: int = 5
var is_vessel: bool = false
var speed: float = 60.0
var is_aggro: bool = false
signal attack(pos,dir,is_evil)
signal hurt(hp,max_hp)
signal boot

var dead = false

func _physics_process(_delta):
	if is_vessel:
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		modulate = Color(1, 1, 1)
	else:
		if !dead:
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, true)
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, true)
			modulate = Color(1, 1, 1)
		else:
			modulate = Color(0.561, 0.0, 0.549)
			set_collision_layer_value(1, false)
			set_collision_layer_value(2, false)
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, false)

	if ((2 < death_timer.time_left) && (death_timer.time_left < 3)) && !warning.visible:
		warning.visible = true

	if !is_vessel:
		speed = 60.0
		if target != null and !dead and target.is_aggro:
			var direction = (target.position - position).normalized()
			velocity = direction * speed
			if atk_cooldown.is_stopped():
				attack.emit(position,direction,true)
				atk_cooldown.start()
		else:
			velocity = Vector2(0,0)

		move_and_slide()
	else:
		speed = 180.0

		if Input.is_action_just_pressed("Primary Action"):
			if atk_cooldown.is_stopped():
				var atk_dir = (get_global_mouse_position() - position).normalized()
				attack.emit(position,atk_dir,false)
				atk_cooldown.start()
				is_aggro = true

func hit():
	if dmg_cooldown.is_stopped():
		health -= 1
		if health == 0:
			if is_vessel:
				boot.emit()
				queue_free()
			else:
				modulate = Color(0.561, 0.0, 0.549)
				dead = true
				set_collision_layer_value(6, true) # make him vessel-able
				death_timer.start()
		dmg_cooldown.start()
		hurt.emit(health,max_health)

func _on_range_body_entered(body):
	target = body
	$Range.scale = Vector2(3.5,3.5)

func _on_range_body_exited(_body):
	target = null
	$Range.scale = Vector2(2.5,2.5)

func _on_revive():
	warning.visible = false
	dead = false
	is_aggro = false
	set_collision_layer_value(6, false) # make him not vessel-able anymore
	if health == 0:
		health = floor(max_health / 2)
	else:
		if is_vessel:
			boot.emit()
