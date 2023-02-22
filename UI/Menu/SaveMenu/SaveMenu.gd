extends Node2D


const SAVEPATH = "user://saves/"
const SAVE_NUMBER = 3

var selectedSlot = -1
onready var saveSlots = $"%SaveSlots"
onready var saveButton = $"%SaveButton"


var savePrefab = preload("res://UI/Menu/SaveMenu/Save.tscn")
var saveSlotInstances = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func selectedNewSlot(slotNumber : int):
	makeSaveAvailableAgain()
	selectedSlot = slotNumber
	for saveSlot in saveSlotInstances:
		if saveSlot.slot != slotNumber:
			saveSlot.pressed = false


func getSavePathFromSlot(saveSlot : int):
	return "%s%s.save" % [SAVEPATH, saveSlot]

func isSaveExist(slotNumber : int):
	var directory = Directory.new();
	return (directory.dir_exists(SAVEPATH) && directory.file_exists(getSavePathFromSlot(slotNumber)))

func getSaveInfo(slotNumber: int):
	var saveInfo = {}
	if isSaveExist(slotNumber):
		var file = File.new()
		file.open(getSavePathFromSlot(slotNumber), File.READ)
		var save = file.get_var()
		file.close()
		saveInfo = save["info"]
	return saveInfo

func save():
	var saveFilePath = getSavePathFromSlot(selectedSlot)
	var newSave = {}

	newSave["info"] = {
		"name" : "Anonymous",
		"room": Rooms.currentRoomId,
		"time": OS.get_datetime()
	}
	newSave["State"] = State.save()
	newSave["Quests"] = Quests.save()
	newSave["Items"] = Items.save()
	newSave["Main"] = SceneTransition.currentGame.save()
	newSave["NPCs"] = NPCs.save()

	commitSave(newSave, saveFilePath)

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


# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(SAVE_NUMBER):
		var saveSlot = savePrefab.instance()
		saveSlot.initData(_i, getSaveInfo(_i))
		saveSlot.selected = funcref(self, "selectedNewSlot")
		saveSlots.add_child(saveSlot)
		saveSlotInstances.push_back(saveSlot)


func _on_BackBtn_pressed():
	SceneTransition.xToYScene(self, Constants.MENU_SCENE_PATH)


func _on_saveButton_pressed():
	save()

	saveButton.disabled = true
	saveButton.text = "saved!"

	for saveSlot in saveSlotInstances:
		if saveSlot.slot == selectedSlot:
			saveSlot.initData(selectedSlot, getSaveInfo(selectedSlot))
			saveSlot.displayData()

	var timer = Timer.new()
	timer.connect("timeout", self, "makeSaveAvailableAgain")
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()

func makeSaveAvailableAgain():
	saveButton.disabled = false
	saveButton.text = "save"
