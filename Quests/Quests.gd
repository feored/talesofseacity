extends Node

const Quest = preload("res://Quests/Quest.gd")
var shaddoxMahjongQuest = preload("res://Quests/ShaddoxMahjong.gd")

var SETUP_QUESTS = true

var elapsedTime = 0

var QUEST_FLAGS = {
	"qHelpShaddoxLookForTiles" : false,
	"qGaveShaddoxBackHisTiles" : false
}

var COMPLETED_QUESTS = [

]

var QUESTS = [
	{
		"id" : "test",
		"script" : shaddoxMahjongQuest,
		"stage" : "initial"
	}
]
# Called when the node enters the scene tree for the first time.

func _ready():
	for quest in QUESTS:
		quest["object"] = quest["script"].new()
		if SETUP_QUESTS && quest["object"].has_method("setup"):
			quest["object"].setup()
		quest["object"].initialize(quest["stage"])

func checkConditions():
	for quest in QUESTS:
		if quest["object"].checkConditions():
			quest["object"].execCompletion()
			var nextStage = quest["object"].getNextStage(quest["stage"])
			quest["stage"] = nextStage
			if nextStage == "final":
				COMPLETED_QUESTS.push_back(quest)
				QUESTS.erase(quest)
			else:
				quest["object"].initialize(quest["stage"])


func _process(delta):
	elapsedTime += delta
	if elapsedTime > 0.5:
		checkConditions()
		elapsedTime = 0
