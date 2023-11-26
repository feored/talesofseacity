extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SHOW_TIMER = 0.5

onready var textBox = get_node("%VNText")

enum VN { NewPage, ShowChar, HideChar, FlipChar, SwitchToNode }

onready var bifChar = get_node("%bif")
onready var mafChar = get_node("%maf")

onready var vn_characters = {"bif": bifChar, "maf": mafChar}

var vn_script = [
	"The developer lounge is rather busy today, I think to myself as I come in.",
	"Usually, there are only ghosts at this time of the day.",
	"There are two people sitting at the table in front of me, and they seem to be deep in conversation.",
	"I guess I'll sit with them.",
	{
		"instruction": VN.NewPage,
	},
	{"instruction": VN.ShowChar, "character": "bif"},
	'"Well, I guess we\'ll have to fix that too...Have you opened an issue?"',
	{"instruction": VN.ShowChar, "character": "maf"},
	'"Not yet, I\'m still busy working on fixing the spin glitch."',
	"As they continue talking about things I don't understand, it dawns on me that these two are the admins of this place. Why do they look so miserable?",
	"They're too busy with their conversation to notice me, so I keep listening in.",
	{
		"instruction": VN.NewPage,
	},
	'"Have you heard? Apparently, someone started a rival site because they were unhappy with the way we do things."',
	'"No, but I wish them well. At least then I could focus on translating this obscure Famicom wrestling game."',
	"Ding, a bell rings.",
	'"What\'s that?"',
	'"Another request to add animations."',
	'"I really need a break..."',
	{
		"instruction": VN.NewPage,
	},
	"They turn their attention to me.",
	{"instruction": VN.FlipChar, "character": "bif"},
	"I have a bad feeling about this.",
	'"I have an idea."',
	'"What if we got someone to help us solve some of the problems in Sea City?"',
	'"They stare at me intently."',
	'"Good luck, Anonymous."',
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
		VN.NewPage:
			textBox.clear()
			next()
		VN.ShowChar:
			showCharacter(instruction["character"], true)
		VN.HideChar:
			showCharacter(instruction["character"], false)
		VN.FlipChar:
			flipCharacter(instruction["character"], true)


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


func skip():
	if script_index >= vn_script.size():
		return
	var currentType = typeof(vn_script[script_index])
	match currentType:
		TYPE_STRING:
			textBox.next()
		TYPE_DICTIONARY:
			next()


func next():
	script_index += 1
	print(script_index)
	print(vn_script.size())
	if script_index >= vn_script.size():
		end()
		return
	var nextType = typeof(vn_script[script_index])
	match nextType:
		TYPE_STRING:
			textBox.addText(vn_script[script_index])
		TYPE_DICTIONARY:
			interpret_instruction(vn_script[script_index])


func setName():
	State.NAME = $"%NameEnter".text


func end():
	SceneTransition.xToY(self, SceneTransition.currentGame)
