class_name Dialog
extends Control
## Displays a dialog text box with the ability to show a speaker tag, and a little continue button.

## Emits when a text chain finishes and the dialog box is closed.
signal finished
## Emits when a text box finishes animating.
signal finished_typing
## Emits when a choice is chosen.
signal selected(choice)

# true if waiting for player to make a choice (so advance_text doesn't break
# choice selections)
var waiting_choice: bool = false
# true if there's a note on screen
var viewing_note: bool = false

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
@onready var _text_box = $TextBox
@onready var _speaker: Label = $TextBox/BoxContainer/Name
@onready var _dialog: RichTextLabel = $TextBox/BoxContainer/Dialog
@onready var _choice_buttons: Array[Node] = $TextBox/BoxContainer/Choices.get_children()
@onready var _cg: TextureRect = $CG
@onready var _note = $Note
@onready var _note_date = $Note/VBoxContainer/Date
@onready var _note_text = $Note/VBoxContainer/NoteText
@onready var _note_signature = $Note/VBoxContainer/Signature

func _input(_event: InputEvent):
	if (Global.player_disabled # if player control is disabled
		and (Input.is_action_just_pressed("Primary Action")
		or Input.is_action_just_pressed("Interact"))
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
	show_box()
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
	waiting_choice = true
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
	return await selected

# advance the text, skipping the animation or closing the box.
func advance_text():
	# if the animation isn't done yet
	if viewing_note:
		close()
		finished.emit()
	elif _dialog.visible_characters < _dialog.get_total_character_count():
		# skips the typing animation
		_dialog.visible_characters = _dialog.get_total_character_count()
	elif !waiting_choice: #if the animation's already done,
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

## Opens the dialog, making it visible.
func open():
	visible = true
	Global.can_pause = false
	show_box()

## Closes the dialog, hiding it.
func close():
	visible = false
	Global.can_pause = false

func show_box():
	_text_box.visible = true

func hide_box():
	_text_box.visible = false

func show_cg(new_img: Texture2D = null):
	if new_img != null:
		_cg.texture = new_img
	get_tree().create_tween().tween_property(_cg, "modulate", Color(1,1,1,1), 0.5)

func hide_cg():
	get_tree().create_tween().tween_property(_cg, "modulate", Color(1,1,1,0), 0.5)

func show_note(new_page: Page) -> Signal:
	var new_date = new_page.date
	var new_text = new_page.text
	var new_sig = new_page.signature

	open()
	hide_box()

	if new_date == "":
		_note_date.visible = false
	else:
		_note_date.visible = true
		_note_date.text = new_date

	_note_text.text = new_text

	if new_sig == "":
		_note_signature.visible = false
	else:
		_note_signature.visible = true
		_note_signature.text = "- " + new_sig

	_note.visible = true
	viewing_note = true
	return finished

func flip_note(new_page: Page) -> Signal:
	var new_date = new_page.date
	var new_text = new_page.text
	var new_sig = new_page.signature

	open()
	hide_box()

	if new_date == "":
		_note_date.visible = false
	else:
		_note_date.visible = true
		_note_date.text = new_date

	_note_text.text = new_text

	if new_sig == "":
		_note_signature.visible = false
	else:
		_note_signature.visible = true
		_note_signature.text = "- " + new_sig

	return finished

func hide_note():
	open()
	hide_box()
	_note.visible = false
	viewing_note = false

func _on_option_pressed(index: int):
	close()
	selected.emit(index)
	waiting_choice = false
