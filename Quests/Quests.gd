extends Node

var testQuest = load("res://Quests/TestQuest.gd")


var elapsedTime = 0

var QUESTS = [
	{
		"id" : "test",
		"script" : testQuest,
		"stage" : "initial"
	}
]
# Called when the node enters the scene tree for the first time.

func _ready():
	for quest in QUESTS:
		quest["object"] = quest["script"].new()
		quest["object"].initialize(quest["stage"])

func checkConditions():
	for quest in QUESTS:
		if quest["object"].checkConditions():
			quest["object"].execCompletion()
			var nextStage = quest["object"].getNextStage(quest["stage"])
			quest["stage"] = nextStage


func _process(delta):
	elapsedTime += delta
	if elapsedTime > 0.5:
		checkConditions()
		elapsedTime = 0
