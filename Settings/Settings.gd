extends Node

## display settings
var FULL_SCREEN = OS.window_fullscreen

## audio settings

## Volume stored as float [0..1]
var MASTER_VOLUME = 0
var MUSIC_VOLUME = 0
var FX_VOLUME = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    display_init()
    Audio.init()


func save() -> Dictionary:
    return {
        "FULL_SCREEN" : FULL_SCREEN,
        "MASTER_VOLUME": MASTER_VOLUME,
        "MUSIC_VOLUME": MUSIC_VOLUME,
        "FX_VOLUME": FX_VOLUME
    }

func load(save : Dictionary) -> void:
    FULL_SCREEN = save["FULL_SCREEN"]

    MASTER_VOLUME = save["MASTER_VOLUME"]
    MUSIC_VOLUME = save["MUSIC_VOLUME"]
    FX_VOLUME = save["FX_VOLUME"]

    display_init()
    Audio.init()

func display_init():
    OS.window_fullscreen = FULL_SCREEN