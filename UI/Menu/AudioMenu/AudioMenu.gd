extends Control


onready var masterSlider = $"%MasterSlider"
onready var musicSlider = $"%MusicSlider"
onready var FXSlider = $"%FXSlider"



# Called when the node enters the scene tree for the first time.
func _ready():
    masterSlider.value = Audio.MASTER_VOLUME
    musicSlider.value = Audio.MUSIC_VOLUME
    FXSlider.value = Audio.FX_VOLUME


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackBtn_pressed():
    queue_free()

func _on_FXSlider_value_changed(value:float):
	Audio.setVolumeFX(value)

func _on_MusicSlider_value_changed(value:float):
	Audio.setVolumeMusic(value)

func _on_MasterSlider_value_changed(value:float):
	Audio.setVolumeMaster(value)
