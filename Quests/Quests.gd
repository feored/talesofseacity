extends Node

const Quest = preload("res://Quests/Quest.gd")
var shaddoxMahjongQuest = preload("res://Quests/ShaddoxMahjong.gd")
var feedThePoorQuest = preload("res://Quests/FeedThePoor.gd")
var findSunCreamQuest = preload("res://Quests/FindSunCream.gd")

var SETUP_QUESTS = true

var elapsedTime = 0

var QUEST_FLAGS = {
	"qHelpShaddoxLookForTiles" : false,
	"qGaveShaddoxBackHisTiles" : false,
	"qHungryCorndogTalked" : false,
	"qTalkedToTanningShii" : false
}

var COMPLETED_QUESTS = [

]

var QUESTS = [
	{
		"id" : "Shaddox_Mahjong",
		"script" : shaddoxMahjongQuest,
		"stage" : "initial"
	},
	{
		"id" : "Feed_The_Poor",
		"script" : feedThePoorQuest,
		"stage" : "initial"
	},
	{
		"id" : "Find_Sun_Cream",
		"script" : findSunCreamQuest,
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
