extends Node

const SAVEPATH = "user://saves/"

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


func commitSave(saveVar : Dictionary, saveFilePath : String):
	var directory = Directory.new();
	if (!directory.dir_exists(SAVEPATH)):
		var err = directory.make_dir(SAVEPATH)
		if err != OK:
			print("Failed to create /saves/ directory to save games into.")
			return
	var file = File.new()
	file.open(saveFilePath, File.WRITE)
	file.store_var(saveVar)
	file.close()


func save():
	var saveFilePath = "%s%s.save" % [SAVEPATH, "savetest"]# OS.get_unix_time()]
	var newSave = {}

	newSave["info"] = {
		"name" : "Anonymous",
		"room": Rooms.currentRoomId,
		"time": OS.get_datetime()
	}
	newSave["State"] = State.save()
	newSave["Quests"] = Quests.save()
	newSave["Items"] = Items.save()
	newSave["Main"] = main.save()
	newSave["NPCs"] = NPCs.save()

	commitSave(newSave, saveFilePath)
	hide()


func loadGame():
	loadSave("%s%s.save" % [SAVEPATH, "savetest"])
	hide()


func loadSave(savePath : String):
	main.setLoading(true)

	var directory = Directory.new();
	if (!directory.dir_exists(SAVEPATH) || !directory.file_exists(savePath)):
		print("Failed to find the save game %s that needs to be loaded." % savePath)
		return

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

func _on_SaveBtn_pressed():
	save()

func _on_AudioBtn_pressed():
	SceneTransition.xToYScene(self, Constants.AUDIOMENU_SCENE_PATH)


func _on_DisplayBtn_pressed():
	SceneTransition.xToYScene(self, Constants.DISPLAYMENU_SCENE_PATH)
