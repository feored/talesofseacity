extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SHOW_TIMER = 0.5
const HIGHLIGHT_TIMER = 0.2
const INACTIVE_CHARACTER_COLOR = Color(0.35, 0.35, 0.35, 1)

onready var textBox = get_node("%VNText")

enum VN { Dialogue, NewPage, ShowChar, HideChar, FlipChar, SwitchToNode }

onready var bifChar = get_node("%bif")
onready var mafChar = get_node("%maf")

onready var vn_characters = {"bif": bifChar, "maf": mafChar}

var vn_script = [
	{"instruction": VN.Dialogue, "speaker": null, "text": "The developer lounge is unusually busy today."},
	{"instruction": VN.Dialogue, "speaker": null, "text": "Most days, it's just me and the ghosts."},
	{"instruction": VN.Dialogue, "speaker": null, "text": "Two people are sitting at the table, and they seem to be deep in conversation."},
	{"instruction": VN.Dialogue, "speaker": null, "text": "I guess I'll sit with them."},
	{
		"instruction": VN.NewPage,
	},
	{"instruction": VN.ShowChar, "character": "bif"},
	{"instruction": VN.Dialogue, "speaker": "bif", "text": '"Well, I guess we\'ll have to fix that too...Have you opened an issue?"'},
	{"instruction": VN.ShowChar, "character": "maf"},
	{"instruction": VN.Dialogue, "speaker": "maf", "text": '"Not yet, I\'m still busy working on fixing the spin glitch."'},
	{"instruction": VN.Dialogue, "speaker": null, "text": "I only understand about half of what they’re saying, but it seems like they're the admins of this place."},
	{"instruction": VN.Dialogue, "speaker": null, "text": "They look exhausted."},
	{"instruction": VN.Dialogue, "speaker": null, "text": "They're too busy with their conversation to notice me, so I keep listening."},
	{
		"instruction": VN.NewPage,
	},
	{"instruction": VN.Dialogue, "speaker": "maf", "text": '"Did you hear? Someone started a rival site. Apparently, they weren’t happy with how we run things."'},
	{"instruction": VN.Dialogue, "speaker": "bif", "text": '"No, but good for them. Maybe now I can get back to translating Super Fire Prowrestling Special..."'},
	{"instruction": VN.Dialogue, "speaker": null, "text": "A notification bell chimes."},
	{"instruction": VN.Dialogue, "speaker": "bif", "text": '"What was that?"'},
	{"instruction": VN.Dialogue, "speaker": "maf", "text": '"Another request to implement animations."'},
	{"instruction": VN.Dialogue, "speaker": "bif", "text": '"I really need a break..."'},
	{
		"instruction": VN.NewPage,
	},
	{"instruction": VN.Dialogue, "speaker": null, "text": "Iccanobif finally notices me."},
	{"instruction": VN.FlipChar, "character": "bif"},
	{"instruction": VN.Dialogue, "speaker": null, "text": "I have a bad feeling about this."},
	{"instruction": VN.Dialogue, "speaker": "bif", "text": '"Wait. I have an idea."'},
	{"instruction": VN.Dialogue, "speaker": "bif", "text": '"What if we found someone else to deal with some of Sea City’s problems?"'},
	{"instruction": VN.Dialogue, "speaker": null, "text": "They both stare at me."},
	{"instruction": VN.Dialogue, "speaker": "maf", "text": '"Good luck, Anonymous."'},
]

var script_index = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	# Audio.setVolumeMaster(1)
	# Audio.setVolumeMusic(1)
	Audio.playMusic(Audio.Music.MysteryAmbient)
	textBox.lineCompleteCallback = funcref(self, "next")
	next()


func _input(event):
	if event.is_action_pressed("interact"):
		skip()


func interpret_instruction(instruction: Dictionary):
	var instructionType = instruction["instruction"]
	match instructionType:
		VN.Dialogue:
			showDialogue(instruction)
		VN.NewPage:
			setActiveSpeaker(null)
			textBox.clear()
			next()
		VN.ShowChar:
			showCharacter(instruction["character"], true)
		VN.HideChar:
			showCharacter(instruction["character"], false)
		VN.FlipChar:
			flipCharacter(instruction["character"], true)
		_:
			push_error("Unknown VN instruction: " + str(instructionType))
			next()


func showCharacter(character: String, show: bool):
	var tween = create_tween()
	tween.tween_property(
		vn_characters[character], "modulate", Color.white if show else Color.transparent, SHOW_TIMER
	)
	tween.tween_callback(self, "next")


func flipCharacter(character: String, flip: bool):
	var tween = create_tween()
	var characterSprite = vn_characters[character]
	tween.tween_property(
		characterSprite,
		"scale",
		Vector2(-1 * characterSprite.scale.x, characterSprite.scale.y),
		SHOW_TIMER
	)
	tween.tween_callback(self, "next")


func setActiveSpeaker(speaker) -> void:
	if speaker != null && !vn_characters.has(speaker):
		push_error("Unknown VN speaker: " + str(speaker))
		speaker = null
	for character in vn_characters:
		var targetColor = Color.white
		if speaker != null && character != speaker:
			targetColor = INACTIVE_CHARACTER_COLOR
		# Keep characters that have not entered the scene transparent.
		targetColor.a = vn_characters[character].modulate.a
		var tween = create_tween()
		tween.tween_property(
			vn_characters[character], "modulate", targetColor, HIGHLIGHT_TIMER
		)


func showDialogue(instruction: Dictionary) -> void:
	if !instruction.has("text") || typeof(instruction["text"]) != TYPE_STRING:
		push_error("VN dialogue instructions require string text")
		next()
		return
	var speaker = instruction.get("speaker", null)
	if speaker != null && typeof(speaker) != TYPE_STRING:
		push_error("VN dialogue speakers must be a character id or null")
		speaker = null
	setActiveSpeaker(speaker)
	textBox.addText(instruction["text"])


func skip():
	if script_index >= vn_script.size():
		return
	var currentInstruction = vn_script[script_index]
	if currentInstruction["instruction"] == VN.Dialogue:
		textBox.next()
	else:
		next()


func next():
	script_index += 1
	print(script_index)
	print(vn_script.size())
	if script_index >= vn_script.size():
		end()
		return
	interpret_instruction(vn_script[script_index])


func setName():
	State.NAME = $"%NameEnter".text


func end():
	SceneTransition.xToY(self, SceneTransition.currentGame)
