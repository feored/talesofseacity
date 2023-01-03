extends Control

var mainScene = preload("res://Main.tscn")

onready var animationPlayer = $"%AnimationPlayer"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_PlayBtn_pressed():
	get_tree().get_root().add_child(mainScene.instance())
	queue_free()

func _on_LoadBtn_pressed():
	pass
	
func _on_SettingsBtn_pressed():
	pass

func _on_QuitBtn_pressed():
	get_tree().quit()
