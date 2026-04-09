class_name EventManager extends Node

@onready var game = $".."
@onready var dialog = $"../UI Layer/Dialog"
@onready var game_over = $"../UI Layer/GameOver"

@onready var church_music = $ChurchMusic
@onready var yard_music = $GraveyardMusic

func fade_track_out(is_church: bool = true):
	var track: AudioStreamPlayer
	if is_church:
		track = church_music
	else:
		track = yard_music

	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(track, "volume_linear", 0, 0.6)
	await tween.finished
	track.stop()

func fade_track_in(is_church: bool = true):
	var track: AudioStreamPlayer
	if is_church:
		track = church_music
	else:
		track = yard_music

	track.play()
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(track, "volume_linear", 0.75, 1)
