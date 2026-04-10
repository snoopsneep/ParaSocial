extends Control

func _input(event):
	if event.is_action_pressed("Pause") and Global.can_pause:
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused # toggle pause
	visible = !visible # toggle visibility
	if visible:
		$OpenMenu.play()
		$CloseMenu.stop()
	else:
		$OpenMenu.stop()
		$CloseMenu.play()

func resume_button():
	toggle_pause()
	$ButtonPress.play()

func settings_button():
	print("Open Settings menu!")
	$ButtonPress.play()

func exit_button():
	print("Exit to Main Menu!")
	$ButtonPress.play()
	$"../GameOver".to_black("","",false,0.5)
	await $"../GameOver".done_fading
	Global.restart_game()

func button_hover():
	$ButtonHover.play()
