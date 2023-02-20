extends Node


onready var musicPlayer = $MusicPlayer

var fxPlayers : Array = []
var fxPlayersAmount : int = 10
onready var fxPlayerId : int = 0


var bus = preload("res://Audio/bus_layout.tres")

var fx_message = preload("res://Audio/FX/message.mp3")
var fx_login = preload("res://Audio/FX/login.mp3")
var music_mysteryAmbient = preload("res://Audio/Music/nicebird.ogg")
var music_happy = preload("res://Audio/Music/bg_2.mp3")

enum FX {
	Message,
	Login
}

enum Music {
	MysteryAmbient,
	Happy
}

var FX_FILES = {
	FX.Message : fx_message,
	FX.Login : fx_login
}

var MUSIC_FILES = {
	Music.MysteryAmbient : music_mysteryAmbient,
	Music.Happy : music_happy
}

# Called when the node enters the scene tree for the first time.
func _ready():
	fxPlayerId = 0
	for _i in range(fxPlayersAmount):
		var fxPlayer : AudioStreamPlayer = AudioStreamPlayer.new()
		fxPlayers.append(fxPlayer)
		add_child(fxPlayer)


func init():
	setVolumeMaster(Settings.MASTER_VOLUME)
	setVolumeFX(Settings.FX_VOLUME)
	setVolumeMusic(Settings.MUSIC_VOLUME)
	playMusic(Music.Happy)


func playMusic(newTrack : int) -> void:
	musicPlayer.stream = MUSIC_FILES[newTrack]
	musicPlayer.play()

func playFX(newFX : int) -> void:
	fxPlayers[fxPlayerId].stream = FX_FILES[newFX]
	fxPlayers[fxPlayerId].play()
	fxPlayerId = (fxPlayerId + 1) % fxPlayersAmount


func setVolumeMaster(newVolume) -> void:
	## Volume in decibel, on scale -60 -> 0
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear2db(newVolume))
	Settings.MASTER_VOLUME = newVolume

func setVolumeFX(newVolume) -> void:
	## Volume in decibel, on scale -60 -> 0
	var bus_index = AudioServer.get_bus_index("FX")
	AudioServer.set_bus_volume_db(bus_index, linear2db(newVolume))
	Settings.FX_VOLUME = newVolume
	playFX(FX.Message)

func setVolumeMusic(newVolume) -> void:
	## Volume in decibel, on scale -60 -> 0
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear2db(newVolume)) 
	Settings.MUSIC_VOLUME = newVolume
