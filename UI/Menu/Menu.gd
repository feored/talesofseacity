extends Node


## funcrefs
var main


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


func hide():
	#visible = false
	SceneTransition.xToY(self, SceneTransition.currentGame)

func _on_ContinueBtn_pressed():
	hide()


	
func _input(event):
	if event.is_action_pressed("menu"):
		quitMenu()

func quitMenu():
	SceneTransition.xToY(self, SceneTransition.currentGame)

func _on_AudioBtn_pressed():
	SceneTransition.xToYScene(self, Constants.AUDIOMENU_SCENE_PATH)

func _on_DisplayBtn_pressed():
	SceneTransition.xToYScene(self, Constants.DISPLAYMENU_SCENE_PATH)

func _on_SaveBtn_pressed():
	SceneTransition.xToYScene(self, Constants.SAVEMENU_SCENE_PATH)

func _on_LoadBtn_pressed():
    SceneTransition.xToYScene(self, Constants.LOADMENU_SCENE_PATH)