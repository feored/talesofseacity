extends Reference
class_name Quest

var main : Node
var currentCondition : Object = funcref(self, "")
var currentCompleted : Object = funcref(self, "")
var currentConditionType : int

var stages : Dictionary
# Called when the node enters the scene tree for the first time.

func checkConditions() -> bool:
	return currentCondition.call_func() if currentCondition.is_valid() else false

func execCompletion() -> void:
	if currentCompleted.is_valid():
		currentCompleted.call_func() 

func getNextStage(currentStage : String) -> String:
	return stages[currentStage]["next"] if stages[currentStage].has("next") else ""

func initialize(currentStage : String):
	currentCondition = funcref(self, stages[currentStage]["condition"]) if stages[currentStage].has("condition") else funcref(self, "")
	currentConditionType = stages[currentStage]["condition_type"] if (stages[currentStage].has("condition") && stages[currentStage].has("condition_type")) else Quests.QuestConditionType.None
	currentCompleted = funcref(self, stages[currentStage]["completed"]) if stages[currentStage].has("completed") else funcref(self, "")


func _init(questStages : Dictionary):
	self.stages = questStages
