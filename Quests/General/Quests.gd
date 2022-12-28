extends Node

const Quest = preload("res://Quests/General/Quest.gd")
var shaddoxMahjongQuest = preload("res://Quests/ShaddoxMahjong.gd")
var feedThePoorQuest = preload("res://Quests/FeedThePoor.gd")
var findSunCreamQuest = preload("res://Quests/FindSunCream.gd")
var bringHostessSushiQuest = preload("res://Quests/BringHostessSushi.gd")
var schoolyardDogsQuest = preload("res://Quests/SchoolyardDogs.gd")
var scienceExperimentQuest = preload("res://Quests/ScienceExperiment.gd")
var blackoutQuest = preload("res://Quests/Blackout.gd")

var currentQuestIndex = 0
var ENABLED = false


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
	"qSushiNewChef" : false,
	##SchoolyardDogs
	"qSetSchoolyardTrap" : false,
	"qFinishedSchoolyardDogs" : false,
	## science experiment
	"qTalkedToScientist" : false,
	"qInsertedChip": false,
	"qInsertedSecondChip": false,
	"qPushedMachine" : 0,
	## blackout
	"qTalkedToBarman" : false,
	"qTalkedToEngineer" : false,
	"qAskedForWrench" : false
}

var COMPLETED_QUESTS = [

]

var QUEST_SCRIPTS = {
	"Shaddox_Mahjong" :
	{
		"script" : shaddoxMahjongQuest
	},
	"Feed_The_Poor":
	{
		"script" : feedThePoorQuest
	},
	"Find_Sun_Cream":
	{
		"script" : findSunCreamQuest
	},
	"Bring_Hostess_Sushi":
	{
		"script" : bringHostessSushiQuest
	},
	"Schoolyards_Dogs":
	{
		"script": schoolyardDogsQuest
	},
	"Science_Experiment":
	{
		"script": scienceExperimentQuest
	},
	"Blackout":
	{
		"script": blackoutQuest,
	}

}

var QUESTS = [
	{
		"id" : "Shaddox_Mahjong",
		"title" : "The Missing Tiles",
		"stage" : "initial"
	},
	{
		"id" : "Feed_The_Poor",
		"title" : "Feed The Poor",
		"stage" : "initial"
	},
	{
		"id" : "Find_Sun_Cream",
		"title" : "Giko in the Sun",
		"stage" : "initial"
	},
	{
		"id" : "Bring_Hostess_Sushi",
		"title" : "Late Night Entertainment",
		"stage" : "initial"
	},
	{
		"id" : "Schoolyards_Dogs",
		"title" : "Schoolyard Bullies",
		"stage" : "initial"
	},
	{
		"id": "Science_Experiment",
		"title": "The Experiment",
		"stage": "initial"
	},
	{
		"id": "Blackout",
		"title": "Blackout in Sea City",
		"stage": "initial"
	}
]

var JOURNAL = {
	
}

var journalRefreshNeeded = true

func _ready():
	pass

func initQuests() -> void:
	var mainNode = get_node("/root/Main/")
	for quest in QUESTS:
		var id = quest["id"]
		QUEST_SCRIPTS[id]["object"] = QUEST_SCRIPTS[id]["script"].new()
		QUEST_SCRIPTS[id]["object"].main = mainNode
		if State.SETUP_QUESTS && QUEST_SCRIPTS[id]["object"].has_method("setup"):
			QUEST_SCRIPTS[id]["object"].setup()
			QUEST_SCRIPTS[id]["object"].initialize(quest["stage"])
	ENABLED = true

func checkConditions():
	if currentQuestIndex > (QUESTS.size() - 1):
		currentQuestIndex = 0
	var quest = QUESTS[currentQuestIndex]
	var questId = quest["id"]
	var questObject = QUEST_SCRIPTS[questId]["object"]
	if questObject.checkConditions():
		questObject.execCompletion()
		var currentQuestStage = questObject["stages"][quest["stage"]]
		if currentQuestStage.has("entry"):
			addJournalEntry(quest["title"], currentQuestStage["entry"]) 
		var nextStage = questObject.getNextStage(quest["stage"])
		QUESTS[currentQuestIndex]["stage"] = nextStage
		if nextStage == "final":
			COMPLETED_QUESTS.push_back(quest)
			QUESTS.remove(currentQuestIndex)
		else:
			questObject.initialize(quest["stage"])
			currentQuestIndex += 1
	else:
		currentQuestIndex += 1

func addJournalEntry(questTitle : String, questEntry: String) -> void:
	if JOURNAL.has(questTitle):
		JOURNAL[questTitle].push_back(questEntry)
	else:
		JOURNAL[questTitle] = [questEntry]
	journalRefreshNeeded = true
	get_node(Constants.NOTIFICATIONS_PATH).addNotification("Journal updated.")

func _process(delta):
	if ENABLED :
		elapsedTime += delta
		if elapsedTime > (TOTAL_TIME_QUEST_CYCLE / QUESTS.size()):
			checkConditions()
			elapsedTime = 0

func save() -> Dictionary:
	return {
		"QUEST_FLAGS" : QUEST_FLAGS,
		"QUESTS" : QUESTS,
		"COMPLETED_QUESTS": COMPLETED_QUESTS,
		"JOURNAL": JOURNAL
	}

func load(save : Dictionary) -> void:
	ENABLED = false

	QUEST_FLAGS = save["QUEST_FLAGS"]
	QUESTS = save["QUESTS"]
	COMPLETED_QUESTS = save["COMPLETED_QUESTS"]
	JOURNAL = save["JOURNAL"]

	initQuests()
	journalRefreshNeeded = true
