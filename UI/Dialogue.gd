extends MarginContainer

var dialogueTextPrefab = preload("res://UI/DialogueText.tscn")
var dialogueChoicePrefab = preload("res://UI/DialogueChoice.tscn")

onready var dialogueAuthor = $"%DialogueAuthor"
onready var dialogueImage = $"%DialogueImage"


var isDialoguing = false

var currentType : int
var currentDialogueLine
var currentChoiceLines = []


var currentLineSet : Dictionary
var currentStage : String

var lastAuthor = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide() -> void:
	visible = false

func show() -> void:
	visible = true

func spawnLine(text : String) -> void:
	var newDialogueLine = dialogueTextPrefab.instance()
	newDialogueLine.lineOverCallback = funcref(self, "lineOver")
	newDialogueLine.setText(text)
	currentDialogueLine = newDialogueLine
	$"%DialogueVBox".add_child(newDialogueLine)

func spawnChoice(text : String, id : int, visibility : bool = true) -> void:
	var newDialogueLine = dialogueChoicePrefab.instance()
	newDialogueLine.setChoice(text, id)
	newDialogueLine.choicePickedCallback = funcref(self, "choicePicked")
	currentChoiceLines.push_back(newDialogueLine)
	$"%DialogueVBox".add_child(newDialogueLine)
	newDialogueLine.visible = visibility


func lineOver() -> void:
	cleanUpLines()
	setNextLineInSet()

func choicePicked(choiceId : int) -> void:
	cleanUpLines()
	setNextLineInSetFromChoice(choiceId)
	
func cleanUpLines() -> void:
	if currentType == Constants.LineType.Text && is_instance_valid(currentDialogueLine):
		currentDialogueLine.queue_free()
	else:
		for obj in currentChoiceLines:
			if is_instance_valid(obj):
				obj.queue_free()
		currentChoiceLines.clear()


func setAuthor(NPC : String) -> void:
	if NPC == "":
		dialogueAuthor.text = ""
		dialogueImage.texture = null
		$"%InfoDialogueContainer".visible = false
		lastAuthor = ""
		return
	$"%InfoDialogueContainer".visible = true
	var npcData = NPCs.NPCs[NPC]
	dialogueAuthor.text = npcData["name"]
	lastAuthor = npcData["name"]
	var newCharacterPath = "res://Characters/" + Constants.CHARACTERS[npcData["character"]] + "/"
	dialogueImage.texture = load(newCharacterPath + Constants.GIKOANIM_FRONT_STANDING + ".png")

func applyNodeActions(line : Dictionary) -> void:
	if line.has("flags"):
		for flagAction in line["flags"]:
			match flagAction["type"]:
				"set":
					Quests.QUEST_FLAGS[flagAction["flag"]] = flagAction["value"]
				"add":
					Quests.QUEST_FLAGS[flagAction["flag"]] += flagAction["value"]
	if line.has("rewards"):
		for reward in line["rewards"]:
			Items.addItemInventory(reward)
	if line.has("costs"):
		for cost in line["costs"]:
			Items.removeItemInventory(cost)


func canShowChoice(choiceLine : Dictionary) -> bool:
	if (!choiceLine.has("condition")):
		return true
	
	if choiceLine["condition"]["type"] == Constants.ConditionType.Flag:
		return Quests.QUEST_FLAGS[choiceLine["condition"]["value"]]

	elif choiceLine["condition"]["type"] == Constants.ConditionType.Item:
		return Items.INVENTORY.has(choiceLine["condition"]["value"])

	elif choiceLine["condition"]["type"] == Constants.ConditionType.NoItem:
		return !Items.INVENTORY.has(choiceLine["condition"]["value"])

	elif choiceLine["condition"]["type"] == Constants.ConditionType.NoFlag:
		return !Quests.QUEST_FLAGS[choiceLine["condition"]["value"]]

	return false
	

func setLineSet(newLineSet : Dictionary, NPC: String) -> void:
	isDialoguing = true
	currentLineSet = newLineSet
	currentStage = newLineSet["info"]["start"]
	setAuthor(NPC)
	setText(currentLineSet[currentStage])

func setNextLineInSet() -> void:
	applyNodeActions(currentLineSet[currentStage])
	if (currentLineSet[currentStage].has("nextId")):
		currentStage = currentLineSet[currentStage]["nextId"]
		setText(currentLineSet[currentStage])
	else:
		hide()
		isDialoguing = false

func setNextLineInSetFromChoice(choicePicked : int = 0) -> void:
	applyNodeActions(currentLineSet[currentStage]["choices"][choicePicked])
	if (currentLineSet[currentStage]["choices"][choicePicked].has("nextId")):
		currentStage = currentLineSet[currentStage]["choices"][choicePicked]["nextId"]
		setText(currentLineSet[currentStage])
	else:
		hide()
		isDialoguing = false
	
func skipToNext() -> void:
	if (currentType == Constants.LineType.Text):
		cleanUpLines()
		setNextLineInSet()

func setText(newLine : Dictionary) -> void:
	#cleanUpLines()
	currentType = newLine["type"]
	if newLine["type"] == Constants.LineType.Text:
		spawnLine(newLine["text"])
		Log.addLog(lastAuthor, currentDialogueLine.text)
	else:
		for i in range(newLine["choices"].size()):
			var visibility: bool = canShowChoice(newLine["choices"][i])
			spawnChoice(newLine["choices"][i]["text"], i, visibility)




