extends Sprite2D

@onready var leafLight = $"Light"
@onready var leafShade = $"Shadow"

var fireTexture = load("res://assets/Graphics/Environments/Graveyard/Grounds/Leaves/Onfire2.PNG")

func ignite():
	leafLight.visible = true
	leafShade.visible = true
	
	texture = fireTexture
	
	
