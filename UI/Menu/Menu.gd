extends Node


## funcrefs
var main


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


func hide():
	#visible = false
	SceneTransition.xToY(self, SceneTransition.currentGame)

func _on_ContinueBtn_pressed():
	hide()





func loadGame():
	hide()


func loadSave(savePath : String):
	main.setLoading(true)

	var file = File.new()
	file.open(savePath, File.READ)
	var save = file.get_var()

	## Load State
	State.load(save["State"])
	Quests.load(save["Quests"])
	Items.load(save["Items"])
	main.load(save["Main"])
	NPCs.load(save["NPCs"])

	file.close()
	main.setLoading(false)

	
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
