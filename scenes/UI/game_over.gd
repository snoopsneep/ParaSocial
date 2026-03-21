extends Control

@onready var title = $Title
@onready var text = $Text
@onready var button = $Button

func _ready():
	modulate = Color(1,1,1,1)
	visible = true
	title.text = Global.game_over_title
	text.text = Global.game_over_text
	button.visible = Global.game_over_button
	fade_in()

func to_black(new_title: String, new_text: String, time: float = 1.0):
	get_tree().paused = true # pause the game
	visible = true # make the game over screen visible
	button.visible = true # make sure the button's visible if it isn't!!
	title.text = new_title # set the title text
	text.text = new_text # set the body text
	var fade_tween: Tween = get_tree().create_tween() # make a new tween
	# make the tween run when the game is paused
	fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	# tween the modulate of the game over screen to fade it in
	fade_tween.tween_property(self, "modulate", Color(1,1,1,1), time)
	await fade_tween.finished # once it's faded in
	$Button.disabled = false # enable the button

func fade_in(time: float = 1.0):
	$Button.disabled = true # disable the button
	var fade_tween = get_tree().create_tween() # make a new tween
	# make that tween run when the game is paused
	fade_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	# tween the modulate of the game over screen to fade it out
	fade_tween.tween_property(self, "modulate", Color(1,1,1,0), time)
	await fade_tween.finished # once it's faded out
	get_tree().paused = false # unpauses the game
	visible = false # hide the game over screen

func game_over():
	var random_tip: String
	# add more tips to this array whenever you feel like it!
	var tips_arr = [
		"TIP: There's more than one solution to every problem.\nTry to get an idea of your surroundings!",
		"TIP: You can control the bodies of unconscious enemies using\nthe SHIFT key nearby them while in your Parasite form.",
		"TIP: You can't control an unwilling vessel, but your followers\nand animals are able to be controlled freely.",
		"TIP: Unconscious enemies will wake up after a short time.\nMake sure you're not controlling them when it happens!",
		"TIP: Some attacks will knock enemies unconscious, while others will\nkill them outright. Try experimenting with different attacks!",
		"TIP: The sight of a statue walking around will surely startle some people.\nMaybe they'd be willing to speak to someone more... human."
	]
	# pick a random tip to show
	random_tip = tips_arr[randi_range(0,tips_arr.size() - 1)]
	to_black("GAME OVER", random_tip)

func puzzle_victory():
	to_black("YOU ESCAPED!", "Congratulations! You completed the PUZZLE ROUTE of the game!\nPlease fill out the feedback form, or start again to find the other route.\nThanks for playing!")

func combat_victory():
	to_black("YOU ESCAPED!", "Congratulations! You completed the COMBAT ROUTE of the game!\nPlease fill out the feedback form, or start again to find the other route.\nThanks for playing!")

func _on_button_pressed():
	Global.game_over_title = title.text
	Global.game_over_text = text.text
	Global.game_over_button = true
	Global.restart_game()
