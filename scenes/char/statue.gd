extends CharacterBody2D

var health: int = 15
@export var max_health: int = 15
var is_vessel: bool = false
var can_vessel: bool = true
var is_aggro: bool = true
var speed: float = 100.0
@onready var atk_cooldown = $"Attack Cooldown"
#region attack access variables
@onready var up_attack = $Attacks/UpAttack/CollisionShape2D
@onready var up_sprite = $Attacks/UpAttack/AnimatedSprite2D
@onready var left_attack = $Attacks/LeftAttack/CollisionShape2D
@onready var left_sprite = $Attacks/LeftAttack/AnimatedSprite2D
@onready var down_attack = $Attacks/DownAttack/CollisionShape2D
@onready var down_sprite = $Attacks/DownAttack/AnimatedSprite2D
@onready var right_attack = $Attacks/RightAttack/CollisionShape2D
@onready var right_sprite = $Attacks/RightAttack/AnimatedSprite2D
#endregion
signal hurt(hp,max_hp)
signal boot

func _physics_process(_delta):

	if is_vessel:
		set_collision_layer_value(1, true)
		set_collision_layer_value(3, false)
		is_aggro = true
	else:
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, true)
		is_aggro = false

	if is_vessel:
		if Input.is_action_just_pressed("alt_up") and atk_cooldown.is_stopped():
			up_attack.disabled = false
			up_sprite.visible = true
			up_sprite.play("default")
			atk_cooldown.start()
		else: if Input.is_action_just_pressed("alt_left") and atk_cooldown.is_stopped():
			left_attack.disabled = false
			left_sprite.visible = true
			left_sprite.play("default")
			atk_cooldown.start()
		else: if Input.is_action_just_pressed("alt_down") and atk_cooldown.is_stopped():
			down_attack.disabled = false
			down_sprite.visible = true
			down_sprite.play("default")
			atk_cooldown.start()
		else: if Input.is_action_just_pressed("alt_right") and atk_cooldown.is_stopped():
			right_attack.disabled = false
			right_sprite.visible = true
			right_sprite.play("default")
			atk_cooldown.start()

# TODO: make a "Vessel" class that all the other vessels inherit from, with
# stuff like hit(), is_vessel, and health (stuff that all vessels need)
func hit():
	health -= 1
	if health == 0:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		boot.emit()
	hurt.emit(health,max_health)

func _on_up_atk_anim_finished():
	up_attack.disabled = true
	up_sprite.stop()
	up_sprite.visible = false

func _on_left_atk_anim_finished():
	left_attack.disabled = true
	left_sprite.stop()
	left_sprite.visible = false

func _on_down_atk_anim_finished():
	down_attack.disabled = true
	down_sprite.stop()
	down_sprite.visible = false

func _on_right_atk_anim_finished():
	right_attack.disabled = true
	right_sprite.stop()
	right_sprite.visible = false

func _on_atk_body_entered(body):
	if "hit" in body:
		body.hit()
