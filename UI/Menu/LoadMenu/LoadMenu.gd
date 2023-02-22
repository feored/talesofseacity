extends Node2D


const SAVEPATH = "user://saves/"
const SAVE_NUMBER = 3

var selectedSlot = -1
onready var saveSlots = $"%SaveSlots"
onready var loadButton = $"%LoadButton"


var savePrefab = preload("res://UI/Menu/SaveMenu/Save.tscn")
var saveSlotInstances = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func selectedNewSlot(slotNumber : int):
	makeLoadAvailable()
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

func loadSave(saveSlot : int):

	if !isSaveExist(saveSlot):
		return

	var file = File.new()
	file.open(getSavePathFromSlot(saveSlot), File.READ)
	var save = file.get_var()

	## Load State
	State.load(save["State"])
	Quests.load(save["Quests"])
	Items.load(save["Items"])
	SceneTransition.currentGame.load(save["Main"])
	NPCs.load(save["NPCs"])

	file.close()
	SceneTransition.currentGame.gameContinue()
	SceneTransition.xToY(self, SceneTransition.currentGame)

func _ready():
	for _i in range(SAVE_NUMBER):
		var saveSlot = savePrefab.instance()
		var saveInfo = getSaveInfo(_i)
		saveSlot.initData(_i, saveInfo)
		if saveInfo.values().size() < 1:
			saveSlot.disabled = true
		saveSlot.selected = funcref(self, "selectedNewSlot")
		saveSlots.add_child(saveSlot)
		saveSlotInstances.push_back(saveSlot)


func _on_BackBtn_pressed():
	SceneTransition.xToYScene(self, Constants.MENU_SCENE_PATH)


func _on_LoadButton_pressed():
	loadSave(selectedSlot)


func makeLoadAvailable():
	loadButton.disabled = false
