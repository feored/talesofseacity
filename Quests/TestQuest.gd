extends Object

var currentCondition : Object = funcref(self, "")
var currentCompleted : Object = funcref(self, "")

var stages = {
	"initial" : {
		"id" : "initial",
		"condition" : "pickedUpTile",
		"next" : "next",
	},
	"next" : {
		"id" : "next",
		"condition" : "talkedToShaddox",
		"next" : "next",
	},
	"final" : {
		"id" : "final",
	}
}

func pickedUpTile() -> bool:
	return Items.INVENTORY.has("mahjong_red_dragon")

func tileCompleted() -> void:
	return

func talkedToShaddox() -> bool:
	return true


func checkConditions() -> bool:
	return currentCondition.call_func() if currentCondition.is_valid() else false

func execCompletion() -> void:
	print("Conditions completed, executing success function")
	if currentCompleted.is_valid():
		currentCompleted.call_func() 

func getNextStage(currentStage : String) -> String:
	return stages[currentStage]["next"] if stages[currentStage].has("next") else ""

func initialize(currentStage : String):
	print("Initializing stage : %s" % currentStage )
	currentCondition = funcref(self, stages[currentStage]["condition"]) if stages[currentStage].has("condition") else funcref(self, "")
	currentCompleted = funcref(self, stages[currentStage]["completed"]) if stages[currentStage].has("completed") else funcref(self, "")

