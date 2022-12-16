extends Quest

var quest_stages = {
	"initial":
	{
		"id": "initial",
		"condition": "talkedToShaddox",
        "entry": "The Mahjong Enthusiast has asked me to look for three missing tiles in his set: the Green, Red and White Dragons.",
		"next": "startedLookingForTiles",
		"completed": "shaddoxDialogueStillLooking"
	},
	"startedLookingForTiles":
	{
		"id": "talkedToShaddox",
		"condition": "pickedUpTiles",
        "entry": "I've found some of the missing tiles that the Mahjong Enthusiast asked me to look for. I should bring them back to him..",
		"next": "foundTiles",
		"completed": "shaddoxDialogueFoundTiles"
	},
	"foundTiles":
	{
		"id": "next",
		"condition": "gaveShaddoxBackTiles",
        "entry": "I've returned all the missing tiles to the Mahjong Enthusiast. He thanked me profusely!",
		"next": "final",
		"completed": "shaddoxThanksAgain"
	},
	"final": {"id": "final"}
}


func _init().(quest_stages):
	pass


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
		Utils.makeSimpleDialogue(
			["Thanks again for finding the tiles! We should play Mahjong some time."]
		)
	)


func shaddoxDialogueStillLooking() -> void:
	NPCs.removeQuestDialogueByName("takadai", "Shaddox", "shaddoxTilesIntro")

	## add new dialogue
	NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"].push_back(
		{
			"info": {"name": "shaddoxStillLooking", "requeue": true, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text": "Still looking for the tiles, huh? So am I!",
			}
		}
	)


func shaddoxDialogueFoundTiles() -> void:
	NPCs.removeQuestDialogueByName("takadai", "Shaddox", "shaddoxStillLooking")
	## add new dialogue
	NPCs.ACTIVE_NPCs["takadai"]["Shaddox"]["lines"].push_back(
		{
			"info": {"name": "shaddoxFoundTiles", "requeue": false, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text":
				"You found the dragon tiles! How could I ever repay you? Let me give you a Christian blessing from the salt mines.",
				"flags": [{"flag": "qGaveShaddoxBackHisTiles", "type": "set", "value": true}]
			}
		}
	)

## SETUP

func setup() -> void:
	NPCs.addQuestDialogue(
		"takadai",
		"Shaddox",
		{
			"info": {"name": "shaddoxTilesIntro", "requeue": true, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text":
				"Hello there! I enjoy playing Mahjong, but I seem to have lost my mahjong tiles. I've looked everywhere...I don't know where I dropped them.",
				"nextId": "ShaddoxTile2"
			},
			"ShaddoxTile2":
			{
				"id": "ShaddoxTile2",
				"type": Constants.LineType.Text,
				"text":
				"Specifically, I'm missing all three of the dragon tiles. The Red, White and Green Dragons. Could you help me look for them?",
				"nextId": "ShaddoxTile3"
			},
			"ShaddoxTile3":
			{
				"id": "ShaddoxTile3",
				"type": Constants.LineType.Choice,
				"choices":
				[
					{
						"text": "Sure!",
						"flags":
						[{"flag": "qHelpShaddoxLookForTiles", "type": "set", "value": true}],
						"nextId": "ShaddoxTile4"
					},
					{
						"text": "Sorry, maybe later.",
						"flags":
						[{"flag": "qHelpShaddoxLookForTiles", "type": "set", "value": false}]
					}
				]
			},
			"ShaddoxTile4":
			{"id": "ShaddoxTile4", "type": Constants.LineType.Text, "text": "God bless you!"}
		}
	)
