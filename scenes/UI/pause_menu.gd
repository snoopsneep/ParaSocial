extends Control

func _input(event):
	if event.is_action_pressed("Pause") and Global.can_pause:
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused # toggle pause
	visible = !visible # toggle visibility

func resume_button():
	toggle_pause()

func settings_button():
	print("Open Settings menu!")

func exit_button():
	print("Exit to Main Menu!")
	Global.restart_game()
