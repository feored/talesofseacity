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
		return
	var npcData = NPCs.NPCs[NPC]
	dialogueAuthor.text = npcData["name"]
	var newCharacterPath = "res://Characters/" + Constants.CHARACTERS[npcData["character"]] + "/"
	dialogueImage.texture = load(newCharacterPath + Constants.GIKOANIM_FRONT_STANDING + ".png")


func setLines(newLines : Array) -> void:
	currentLines = newLines
	setText(currentLines.pop_front())

func setText(newLine : String) -> void:
	dialogueText.bbcode_text = newLine
	dialogueText.set_visible_characters(0)
	elapsedTime = 0
	showingText = true

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

