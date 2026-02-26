extends Node
# This Global script handles saving and loading. You've gotta update the
# saved variables when you actually have stuff to save.

#TODO: rethink how this works for scene switching
# storing a reference to the menu scene for switching
var menu: PackedScene = preload("res://scenes/main/main_menu/main_menu.tscn")

#TODO: add whatever variables you actually need to save
# save file/progression related variables
var level: int = 0

# saving your game
func save():
	# access the save file with the FileAccess class
	# FileAccess has a bunch of handy methods for saving and loading
	# for example, open() takes a filepath (as a string) and a flag
	# that tells the program if you're WRITE-ing, READ-ing, etc.
	var save_file: FileAccess = FileAccess.open("user://save_file.sav", FileAccess.WRITE)

	# make a neat little dictionary of the save file info
	# not typed so the save file can have multiple different types of data
	var save_dict: Dictionary = {
		"level" : level,
	}

	# turn the dictionary into a JSON string, and then store it in the save file
	# note that stringify() can take almost any data type,
	# but turns all numbers into floats
	var json_string: String = JSON.stringify(save_dict)
	# store_line() does what you think. it stores the data as one line, with a
	# newline (\n) character at the end so you can store another line after.
	# here, we're just storing a file of one line for ease of use
	save_file.store_line(json_string)

# loading the game
func load_game():
	# first, check if the save file actually exists
	if !FileAccess.file_exists("user://save_file.sav"):
		# if it doesn't, just quickly save with the default values
		save()
	# access the save file like earlier, but in READ mode this time
	var save_file: FileAccess = FileAccess.open("user://save_file.sav",FileAccess.READ)
	# get the one line from the save file (so ALL the data)
	var json_string: String = save_file.get_line()
	# instantiate a new JSON, so we can use its functions
	var json: JSON = JSON.new()
	# when you parse a json, it returns the type "Error"
	# if the parse goes okay, the json is changed and the Error is the value OK
	# no string or anything. just OK.
	var parse_result: Error = json.parse(json_string)
	# if the parse DIDN'T return OK, meaning it fucked up somehow
	if parse_result != OK:
		# get_error_message() after getting an error from JSON.parse
		# gets you a string telling you what went wrong.
		# get_error_line is similar.
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		# return after printing that error so you don't try to load data
		# that doesn't exist
		return
	# actually set all of the variables to the data from the json
	# (its a dictionary so you access it like one, remember?)
	level = json.data["level"]
