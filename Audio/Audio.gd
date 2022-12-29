extends Node


onready var musicPlayer = $MusicPlayer
onready var FXPlayer = $FXPlayer

var MASTER_VOLUME = 0
var MUSIC_VOLUME = 0
var FX_VOLUME = 0

var bus = preload("res://Audio/bus_layout.tres")

var fx_message = preload("res://Audio/FX/message.mp3")
var fx_login = preload("res://Audio/FX/login.mp3")
var music_mysteryAmbient = preload("res://Audio/Music/nicebird.ogg")

enum FX {
	Message,
	Login
}

enum Music {
	MysteryAmbient
}

var FX_FILES = {
	FX.Message : fx_message,
	FX.Login : fx_login
}

var MUSIC_FILES = {
	Music.MysteryAmbient : music_mysteryAmbient
}

# Called when the node enters the scene tree for the first time.
func _ready():
	playMusic(Music.MysteryAmbient)


func playMusic(newTrack : int) -> void:
	musicPlayer.stream = MUSIC_FILES[newTrack]
	musicPlayer.play()

func playFX(newFX : int) -> void:
	FXPlayer.stream = FX_FILES[newFX]
	FXPlayer.play()


func setVolumeMaster(newVolume) -> void:
	## Volume in decibel, on scale -60 -> 0
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, newVolume)
	MASTER_VOLUME = newVolume

func setVolumeFX(newVolume) -> void:
	## Volume in decibel, on scale -60 -> 0
	var bus_index = AudioServer.get_bus_index("FX")
	AudioServer.set_bus_volume_db(bus_index, newVolume)
	FX_VOLUME = newVolume
	playFX(FX.Message)

func setVolumeMusic(newVolume) -> void:
	## Volume in decibel, on scale -60 -> 0
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, newVolume)  
	MUSIC_VOLUME = newVolume
