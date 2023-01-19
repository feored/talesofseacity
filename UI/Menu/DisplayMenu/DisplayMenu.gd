extends Control


onready var fullScreen = $"%FullScreenSlider"

# funcref
var remove : Object


# Called when the node enters the scene tree for the first time.
func _ready():
	fullScreen.pressed = Settings.FULL_SCREEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FullScreenSlider_toggled(button_pressed:bool):
	Settings.FULL_SCREEN = button_pressed
	OS.window_fullscreen = button_pressed

func _on_BackBtn_pressed():
	remove.call_func()
