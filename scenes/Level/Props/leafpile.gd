extends WorldObject

@onready var sprite = $Sprite
@onready var light = $Sprite/Light
@onready var smoke = $Sprite/Smoke

var ignited: bool = false

func ignite():
	light.visible = true
	smoke.visible = true
	sprite.play("burn")
	ignited = true
