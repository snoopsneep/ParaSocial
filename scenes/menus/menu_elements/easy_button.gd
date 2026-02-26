extends Button
class_name EasyButton

#region Overridden Methods
#override this function w/ inheritance to give your buttons hover functionality
#customize easybuttons with small scripts as you need them. making a lot of scripts isn't wrong.
func hover(is_hovering: bool):
	print(str(name) + " button hovering? " + str(is_hovering))

#same shit as hover(), override w/ inheritance to add click functionality
func click():
	print(str(name) + " button click!")
#endregion

#region Signal Methods
#triggered on mouse_entered/exited() signal, triggers the hover() function for easy overriding
func _on_hover(is_hovering: bool):
	hover(is_hovering)

#triggered on button_up() signal, triggers the click() function
func _on_click():
	click()
#endregion
