extends Node2D

var mainScene = preload("res://Main.tscn")

onready var animationPlayer = $"%AnimationPlayer"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_PlayBtn_pressed():
    SceneTransition.xToY(self, SceneTransition.currentGame)
    #SceneTransition.changeScene("res://Cutscenes/Intro.tscn")

func _on_LoadBtn_pressed():
	SceneTransition.xToYScene(self, Constants.LOADMENU_SCENE_PATH)
	
func _on_SettingsBtn_pressed():
	SceneTransition.xToYScene(self, Constants.MENU_SCENE_PATH)

func _on_QuitBtn_pressed():
	get_tree().quit()
