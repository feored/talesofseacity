extends Node

const Quest = preload("res://Quests/General/Quest.gd")
var shaddoxMahjongQuest = preload("res://Quests/ShaddoxMahjong.gd")
var feedThePoorQuest = preload("res://Quests/FeedThePoor.gd")
var findSunCreamQuest = preload("res://Quests/FindSunCream.gd")
var bringHostessSushiQuest = preload("res://Quests/BringHostessSushi.gd")
var schoolyardDogsQuest = preload("res://Quests/SchoolyardDogs.gd")
var scienceExperimentQuest = preload("res://Quests/ScienceExperiment.gd")
var blackoutQuest = preload("res://Quests/Blackout.gd")
var beachedSalmonQuest = preload("res://Quests/BeachedSalmon.gd")

var currentQuestIndex = 0
var ENABLED = false


var elapsedTime = 0
const TOTAL_TIME_QUEST_CYCLE = 0.25

enum QuestConditionType {
	Flag,
	Item
	Position,
	None
}

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
	##BringHostessSushi / BeachedSalmon
	"qTalkedToSushiSalaryman" : false,
	"qTalkedToHostess" : false,
	"qSushiNeedSalmon" : false,
	"qSushiNewSalmon" : false,
	"qPushedSalmon": 0,
	"qSushiGaveSalmon" : false,
	"qSushiConvincedHostess" : false,
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
		"script": blackoutQuest
	},
	"Beached_Salmon":
	{
		"script": beachedSalmonQuest
	}

}

var QUESTS = {
	"Shaddox_Mahjong": {
		"id" : "Shaddox_Mahjong",
		"title" : "The Missing Tiles",
		"stage" : "initial"
	},
	"Feed_The_Poor" : {
		"id" : "Feed_The_Poor",
		"title" : "Feed The Poor",
		"stage" : "initial"
	},
	"Find_Sun_Cream" : {
		"id" : "Find_Sun_Cream",
		"title" : "Giko in the Sun",
		"stage" : "initial"
	},
	"Bring_Hostess_Sushi": {
		"id" : "Bring_Hostess_Sushi",
		"title" : "Late Night Entertainment",
		"stage" : "initial"
	},
	"Schoolyards_Dogs" : {
		"id" : "Schoolyards_Dogs",
		"title" : "Schoolyard Bullies",
		"stage" : "initial"
	},
	"Science_Experiment" : {
		"id": "Science_Experiment",
		"title": "The Experiment",
		"stage": "initial"
	},
	"Blackout": {
		"id": "Blackout",
		"title": "Blackout in Sea City",
		"stage": "initial"
	},
	"Beached_Salmon": {
		"id": "Beached_Salmon",
		"title": "Beached Salmon",
		"stage": "initial"
	}
}

var JOURNAL = {
	
}

var journalRefreshNeeded = true

func _ready():
	pass

func updateFlag(flagAction : Dictionary):
	match flagAction["type"]:
		"set":
			QUEST_FLAGS[flagAction["flag"]] = flagAction["value"]
		"add":
			QUEST_FLAGS[flagAction["flag"]] += flagAction["value"]
	checkConditions(QuestConditionType.Flag)


func checkConditions(conditionType : int) -> void:
	for questId in QUESTS:
		var questObject = QUEST_SCRIPTS[questId]["object"]
		if questObject.currentConditionType == conditionType:
			checkConditionsQuest(questId)
		
func checkConditionsQuest(questId : String) -> void:
	var questObject = QUEST_SCRIPTS[questId]["object"]
	var quest = QUESTS[questId]
	if questObject.checkConditions():
		questObject.execCompletion()
		
		var currentQuestStage = questObject["stages"][quest["stage"]]
		if currentQuestStage.has("entry"):
			addJournalEntry(quest["title"], currentQuestStage["entry"]) 
		var nextStage = questObject.getNextStage(quest["stage"])
		QUESTS[questId]["stage"] = nextStage

		if nextStage == "final":
			COMPLETED_QUESTS.push_back(quest)
			QUESTS.erase(questId)
		else:
			questObject.initialize(quest["stage"])

func initQuests() -> void:
	var mainNode = SceneTransition.currentGame
	for id in QUESTS:
		QUEST_SCRIPTS[id]["object"] = QUEST_SCRIPTS[id]["script"].new()
		QUEST_SCRIPTS[id]["object"].main = mainNode
		if State.SETUP_QUESTS:
			if  QUEST_SCRIPTS[id]["object"].has_method("setup"):
				QUEST_SCRIPTS[id]["object"].setup()
			QUEST_SCRIPTS[id]["object"].initialize(QUESTS[id]["stage"])
	ENABLED = true

func addJournalEntry(questTitle : String, questEntry: String) -> void:
	if JOURNAL.has(questTitle):
		JOURNAL[questTitle].push_back(questEntry)
	else:
		JOURNAL[questTitle] = [questEntry]
	journalRefreshNeeded = true
	get_node(Constants.NOTIFICATIONS_PATH).addNotification("Journal updated.")

func _process(delta):
	pass

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
