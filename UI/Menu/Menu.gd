extends Control

const SAVEPATH = "user://saves/"

## funcrefs
var saveMain : Object
var loadMain : Object


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# func takeScreenshot() -> void:
#     var screenshot = get_viewport().get_texture().get_data()
#     screenshot.flip_y()
#     screenshot.save_png("user://%s.png" % OS.get_unix_time())


# func _on_ScreenshotBtn_pressed():
#     var UINode = get_node("%UI")
#     UINode.scale = Vector2(0, 0)
#     takeScreenshot()
#     UINode.scale = Vector2(1, 1)


func show():
	visible = true

func hide():
	visible = false

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
	newSave["State"] = State.save()
	newSave["Quests"] = Quests.save()
	newSave["Items"] = Items.save()
	newSave["Main"] = saveMain.call_func()

	commitSave(newSave, saveFilePath)
	hide()


func loadGame():
	loadSave("%s%s.save" % [SAVEPATH, "savetest"])
	hide()


func loadSave(savePath : String):
	print("Loading save %s" % savePath)

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
	loadMain.call_func(save["Main"])

	file.close()
	
	


func _on_SaveBtn_pressed():
	save()


func _on_LoadBtn_pressed():
	loadGame()
