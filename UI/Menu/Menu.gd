extends Node

const SAVEPATH = "user://saves/"

var audioMenuPrefab = preload("res://UI/Menu/AudioMenu/AudioMenu.tscn")
var displayMenuPrefab = preload("res://UI/Menu/DisplayMenu/DisplayMenu.tscn")

## funcrefs
var main
onready var menuBase = $"%MenuBase"

onready var menuChildren = [menuBase]


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


func openAudioMenu() -> void:
	var audioMenu = audioMenuPrefab.instance()
	audioMenu.remove = funcref(self, "quitMenu")
	$UI.add_child(audioMenu)
	for m in menuChildren:
		m.visible = false
	menuChildren.push_back(audioMenu)

func openDisplayMenu() -> void:
	var displayMenu = displayMenuPrefab.instance()
	displayMenu.remove = funcref(self, "quitMenu")
	$UI.add_child(displayMenu)
	for m in menuChildren:
		m.visible = false
	menuChildren.push_back(displayMenu)

func hide():
	#visible = false
	SceneTransition.menuToGame()

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
	if menuChildren.size() == 1:
		hide()
	else:
		menuChildren.pop_back().queue_free()
		menuChildren[-1].visible = true

func _on_SaveBtn_pressed():
	save()



func _on_AudioBtn_pressed():
	openAudioMenu()


func _on_DisplayBtn_pressed():
	openDisplayMenu()
