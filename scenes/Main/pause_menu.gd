extends Control

@onready var title = $Title
@onready var text = $Text
@onready var resume = $resume
@onready var restart = $restart

var menu_open = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		to_black()

func to_black(time: float = 1.0):
	get_tree().paused = true # pause the game
	visible = true # make the game over screen visible
	resume.visible = true # make sure the button's visible if it isn't!!
	restart.visible = true # make sure the button's visible if it isn't!!
	var fade_tween: Tween = get_tree().create_tween() # make a new tween
	# make the tween run when the game is paused
	fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	# tween the modulate of the game over screen to fade it in
	fade_tween.tween_property(self, "modulate", Color(1,1,1,1), time)
	await fade_tween.finished # once it's faded in
	resume.disabled = false # enable the button
	restart.disabled = false # enable the button

func fade_in(time: float = 1.0):
	resume.disabled = true # disable the button
	restart.disabled = true # disable the button
	var fade_tween = get_tree().create_tween() # make a new tween
	# make that tween run when the game is paused
	fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	# tween the modulate of the game over screen to fade it out
	fade_tween.tween_property(self, "modulate", Color(1,1,1,0), time)
	await fade_tween.finished # once it's faded out
	get_tree().paused = false # unpauses the game
	visible = false # hide the game over screen

func _on_restart_pressed() -> void:
	Global.restart_game()

func _on_resume_pressed() -> void:
	fade_in()
