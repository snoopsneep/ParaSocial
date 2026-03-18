class_name Dialog
extends Control
## Displays a dialog text box with the ability to show a speaker tag, and a little continue button.

## Emits when a text chain finishes and the dialog box is closed.
signal finished
## Emits when a text box finishes animating.
signal finished_typing
## Emits when a choice is chosen.
signal selected(choice)

# an array that holds the current lines of dialog as Strings,
# forced to forgo strict typing for reasons i don't quite understand
var _lines
# the current name to be displayed as the speaker
var _speaker_name: String
# the current index of _lines being displayed
var _curr_line: int = 0
# how long the typing animation has been playing
var _typing_time: float = 0
# how fast the letters are typed
@export var typing_speed: float = 1.5

# obligatory handy @onready variables
@onready var _speaker: Label = $Box/MarginContainer/VBoxContainer/Name
@onready var _dialog: RichTextLabel = $Box/MarginContainer/VBoxContainer/Dialog
@onready var _choice_buttons: Array[Node] = $Box/MarginContainer/Choices.get_children()

func _input(_event: InputEvent):
	if (Global.player_disabled # if player control is disabled
		and Input.is_action_just_pressed("Primary Action")
	):
		# you can click or press E to advance text
		advance_text()

## Applies the speaker name and current line to the dialog box and handles the typing animation.
func next_line():
	# hide choice buttons before showing the next line, just in case.
	for i in _choice_buttons:
		i.visible = false
	# makes the speaker label visible only if the speaker parameter isn't empty
	_speaker.visible = (_speaker_name != "")
	# applies the speaker text to the label
	_speaker.text = _speaker_name
	# applies the given line to the [RichTextLabel]
	_dialog.text = _lines[_curr_line]
	# sets the visible characters to 0, to allow us to slowly reveal the text as the typing animation.
	_dialog.visible_characters = 0
	# opens the dialog box, making it actually visible
	open()
	# while loop that increases the visible characters until they're all visible
	while _dialog.visible_characters < _dialog.get_total_character_count():
		# typing time adds delta time every frame, effectively storing how long the typing has gone on
		_typing_time += get_process_delta_time()
		# this warning was useless and annoying. i probably shouldn't do this but oh well
		@warning_ignore("narrowing_conversion")
		# visible characters are set based on the text speed (from the settings) and the typing time
		_dialog.visible_characters = typing_speed * _typing_time
		# wait for the next frame, allowing other stuff to run in the background
		await get_tree().process_frame
	# reset _typing_time after the loop
	_typing_time = 0
	# signal that it's finished typing
	finished_typing.emit()

## Displays a single line of text, with the speaker's name as an optional parameter. [br][br]
## Returns a signal that emits when the dialog box closes.
func display_line(line: String, speaker: String = "") -> Signal:
	# set the current array of lines to an array with just the one line
	_lines = [line]
	# set the speaker name
	_speaker_name = speaker
	# reset the current line
	_curr_line = 0
	# show the line
	next_line()
	# return the signal that will emit after the text box is closed
	return finished

# TODO: this method isn't actually implemented yet. fuck you, past ian.
## Displays multiple lines of text in a row, with a single speaker's name as an optional parameter. [br][br]
## Returns a signal that emits when the dialog box closes.
func display_multiline(lines, speaker: String = "") -> Signal:
	# set the current array of lines to the ones to display.
	_lines = lines
	# set the speaker name
	_speaker_name = speaker
	# reset the current line
	_curr_line = 0
	# show the first line
	next_line()
	# return the signal that will emit after the text box is closed.
	return finished

## Displays a [String] of text in a dialog box, as well as presenting the player with multiple
## choices, stored as Strings in an [Array].
## Please note: If options are too long, text will start looking wonky.
func display_choices(line: String, choices) -> int:
	# set the current array of lines to an array with just the one line
	_lines = [line]
	# set the speaker name
	_speaker_name = ""
	# reset the current line
	_curr_line = 0
	# show the line
	next_line()
	# wait until it finishes animating
	await finished_typing
	for i in _choice_buttons.size():
		if i < choices.size():
			_choice_buttons[i].text = choices[i]
			_choice_buttons[i].visible = true
			match choices.size():
				3:
					_choice_buttons[i].text = _choice_buttons[i].text.substr(0,15)
				4:
					_choice_buttons[i].text = _choice_buttons[i].text.substr(0,12)
				5:
					_choice_buttons[i].text = _choice_buttons[i].text.substr(0,10)
		else:
			_choice_buttons[i].visible = false
	_choice_buttons[0].grab_focus()
	return await selected

## Opens the dialog box, making it visible.
func open():
	visible = true

## Closes the dialog box, hiding it.
func close():
	visible = false

# advance the text, skipping the animation or closing the box.
func advance_text():
	# if the animation isn't done yet
	if _dialog.visible_characters < _dialog.get_total_character_count():
		# skips the typing animation
		_dialog.visible_characters = _dialog.get_total_character_count()
	else: #if the animation's already done,
		# skips to the next line
		_curr_line += 1
		# makes sure a "next line to skip to" even exists
		if _curr_line < _lines.size(): #if so,
			# display the next line in the sequence
			next_line()
		else: #if that was the last line,
			# close the text box
			close()
			# and emit the finished signal
			finished.emit()

func _on_option_pressed(index: int):
	close()
	selected.emit(index)
