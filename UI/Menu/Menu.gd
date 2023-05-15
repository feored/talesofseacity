extends Node


## funcrefs
var main


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	if SceneTransition.titleScreen:
		$"%SaveBtn".visible = false
		$"%LoadBtn".visible = false
		$"%ContinueBtn".text = "back"



func _on_ContinueBtn_pressed():
	quitMenu()


	
func _input(event):
	if event.is_action_pressed("menu"):
		quitMenu()

func quitMenu():
	if SceneTransition.titleScreen:
		SceneTransition.xToYScene(self, Constants.TITLESCREEN_SCENE_PATH)
	else:
		SceneTransition.xToY(self, SceneTransition.currentGame)

func _on_AudioBtn_pressed():
	SceneTransition.xToYScene(self, Constants.AUDIOMENU_SCENE_PATH)

func _on_DisplayBtn_pressed():
	SceneTransition.xToYScene(self, Constants.DISPLAYMENU_SCENE_PATH)

func _on_SaveBtn_pressed():
	SceneTransition.xToYScene(self, Constants.SAVEMENU_SCENE_PATH)

func _on_LoadBtn_pressed():
	SceneTransition.xToYScene(self, Constants.LOADMENU_SCENE_PATH)
