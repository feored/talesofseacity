extends Node

const Quest = preload("res://Quests/Quest.gd")
var shaddoxMahjongQuest = preload("res://Quests/ShaddoxMahjong.gd")
var feedThePoorQuest = preload("res://Quests/FeedThePoor.gd")
var findSunCreamQuest = preload("res://Quests/FindSunCream.gd")
var bringHostessSushiQuest = preload("res://Quests/BringHostessSushi.gd")

var currentQuestIndex = 0

var SETUP_QUESTS = true

var elapsedTime = 0
const TOTAL_TIME_QUEST_CYCLE = 1

var QUEST_FLAGS = {
    ##ShaddoxMahjong
    "qHelpShaddoxLookForTiles" : false,
    "qGaveShaddoxBackHisTiles" : false,
    ##FeedThePoor
    "qHungryCorndogTalked" : false,
    ##FindSunCream
    "qTalkedToTanningShii" : false,
    ##CrazyTrashBoon
    "qTalkedToCrazyBoon" : false,
    ##BringHostessSushi
    "qTalkedToSushiSalaryman" : false,
    "qTalkedToHostess" : false,
    "qSushiNewChef" : false
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
    },
    {
        "id" : "Bring_Hostess_Sushi",
        "script" : bringHostessSushiQuest,
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
    if currentQuestIndex > (QUESTS.size() - 1):
        currentQuestIndex = 0
    var quest = QUESTS[currentQuestIndex]
    if quest["object"].checkConditions():
        quest["object"].execCompletion()
        var nextStage = quest["object"].getNextStage(quest["stage"])
        QUESTS[currentQuestIndex]["stage"] = nextStage
        if nextStage == "final":
            COMPLETED_QUESTS.push_back(quest)
            QUESTS.remove(currentQuestIndex)
        else:
            quest["object"].initialize(quest["stage"])
            currentQuestIndex += 1
    else:
        currentQuestIndex += 1


func _process(delta):
    elapsedTime += delta
    if elapsedTime > (TOTAL_TIME_QUEST_CYCLE / QUESTS.size()):
        checkConditions()
        elapsedTime = 0
