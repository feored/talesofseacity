extends MarginContainer


onready var dialogueText = $"%DialogueText"
onready var dialogueAuthor = $"%DialogueAuthor"
onready var dialogueImage = $"%DialogueImage"

const DEFAULT_DELAY = 2

var elapsedTime = 0
var showingText = false
var timeToNext = DEFAULT_DELAY
var shouldHang = false
var currentLines = []
var lastAuthor = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide() -> void:
	visible = false

func show() -> void:
	visible = true

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


func setLines(newLines : Array, NPC: String) -> void:
	if currentLines.size() > 0:
		setText(currentLines.pop_front())
		return
	setAuthor(NPC)
	currentLines = newLines
	setText(currentLines.pop_front())

func setText(newLine : String) -> void:
	dialogueText.bbcode_text = newLine
	dialogueText.set_visible_characters(0)
	elapsedTime = 0
	showingText = true
	timeToNext = DEFAULT_DELAY
	Log.addLog(lastAuthor, dialogueText.text)

func _process(delta):
	if showingText:
		elapsedTime += delta
		dialogueText.set_visible_characters(int(elapsedTime*30))
		if dialogueText.visible_characters >= dialogueText.get_total_character_count():
			showingText = false
			shouldHang = true
			timeToNext = DEFAULT_DELAY
	if shouldHang:
		timeToNext -= delta
		if timeToNext <= 0:
			shouldHang = false
			if currentLines.size() > 0:
				setText(currentLines.pop_front())
			else:
				hide()

