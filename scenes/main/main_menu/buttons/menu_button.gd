extends EasyButton

#TODO: attach hover to button hover audio when true
#TODO: might need to do global/master stuff first

func hover(is_hovering: bool):
	if is_hovering: #mouse moved on
		$ButtonHover.play()

func click():
	pass
