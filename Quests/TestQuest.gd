extends Object

var currentCondition : Object = funcref(self, "")
var currentCompleted : Object = funcref(self, "")

var stages = {
	"initial" : {
		"id" : "initial",
		"condition" : "talkedToShaddox",
		"next" : "startedLookingForTiles",
		"completed" : "shaddoxDialogueStillLooking"
	},
	"startedLookingForTiles" : {
		"id" : "talkedToShaddox",
		"condition" : "pickedUpTiles",
		"next" : "foundTiles",
		"completed" : "shaddoxDialogueFoundTiles"
	},
	"foundTiles" : {
		"id" : "next",
		"condition" : "gaveShaddoxBackTiles",
		"next" : "final",
		"completed" : "shaddoxThanksAgain"
	},
	"final" : {
		"id" : "final"
	}
}

## CONDITIONS

func talkedToShaddox() -> bool:
	return Quests.QUEST_FLAGS["qHelpShaddoxLookForTiles"]

func pickedUpTiles() -> bool:
	return Items.INVENTORY.has("mahjong_red_dragon")

func gaveShaddoxBackTiles() -> bool:
	return Quests.QUEST_FLAGS["qGaveShaddoxBackHisTiles"]

## COMPLETED

func shaddoxThanksAgain() -> void:
	## remove tiles
	Items.removeItemInventory("mahjong_red_dragon")
	## dont need to remove previous dialogue as it is not requeued
	NPCs.NPCs["Shaddox"]["lines"].push_back(
		Utils.makeSimpleDialogue(["Thanks again for finding the tiles! We should play Mahjong sometimes."])
	)

func shaddoxDialogueStillLooking() -> void:
	removeDialogueByName("shaddoxTilesIntro")
	
	## add new dialogue
	NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"].push_back(
		{
			"info" : {
				"name" : "shaddoxStillLooking",
				"requeue" : true,
				"start" : "start"
			},
			"start" : {
				"id" : "start",
				"type" : Constants.LineType.Text,
				"text": "Still looking for the tiles, huh? So am I!",
			}
		}
	)



func shaddoxDialogueFoundTiles() -> void:
	
	removeDialogueByName("shaddoxStillLooking")
	## add new dialogue
	NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"].push_back(
		{
			"info" : {
				"name" : "shaddoxFoundTiles",
				"requeue" : false,
				"start" : "start"
			},
			"start" : {
				"id" : "start",
				"type" : Constants.LineType.Text,
				"text": "You found the dragon tiles! How could I ever repay you? Let me give you a Christian blessing from the salt mines.",
				"flags" : [
					{
						"flag": "qGaveShaddoxBackHisTiles",
						"type": "set",
						"value": true
					}
				]
			}
		}
	)


## UTILS
func removeDialogueByName(dialogueName : String) -> void:
	## remove old dialogue from active lines
	var dialogueIndex = 0
	var foundDialogue = false
	for i in range(NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"].size()):
		if (NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"][i]["info"]["name"] == dialogueName):
			dialogueIndex = i
			foundDialogue = true
	if foundDialogue:
		NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"].remove(dialogueIndex)

func checkConditions() -> bool:
	return currentCondition.call_func() if currentCondition.is_valid() else false

func execCompletion() -> void:
	if currentCompleted.is_valid():
		currentCompleted.call_func() 

func getNextStage(currentStage : String) -> String:
	return stages[currentStage]["next"] if stages[currentStage].has("next") else ""

func initialize(currentStage : String):
	print("Initializing stage : %s" % currentStage )
	currentCondition = funcref(self, stages[currentStage]["condition"]) if stages[currentStage].has("condition") else funcref(self, "")
	currentCompleted = funcref(self, stages[currentStage]["completed"]) if stages[currentStage].has("completed") else funcref(self, "")

