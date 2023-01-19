extends Control


onready var masterSlider = $"%MasterSlider"
onready var musicSlider = $"%MusicSlider"
onready var FXSlider = $"%FXSlider"

# funcref
var remove : Object


# Called when the node enters the scene tree for the first time.
func _ready():
	masterSlider.value = Settings.MASTER_VOLUME*100
	musicSlider.value = Settings.MUSIC_VOLUME*100
	FXSlider.value = Settings.FX_VOLUME*100


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackBtn_pressed():
	remove.call_func()

func _on_FXSlider_value_changed(value:float):
	Audio.setVolumeFX((value/100))

func _on_MusicSlider_value_changed(value:float):
	Audio.setVolumeMusic((value/100))

func _on_MasterSlider_value_changed(value:float):
	Audio.setVolumeMaster((value/100))
