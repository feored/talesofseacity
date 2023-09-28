extends Quest

var quest_stages = {
	"initial":
	{
		"id": "initial",
		"condition": "talkedToOosGiko",
		"condition_type": Quests.QuestConditionType.Flag,
		"completed": "oosGikoExit",
		"entry":
		"I convinced a giko on the larger side to start exercising. I hope he follows through!",
		"next": "final"
	},
	"final": {"id": "final"}
}


func _init().(quest_stages):
	pass


## CONDITIONS


func talkedToOosGiko() -> bool:
	return Quests.QUEST_FLAGS["qTalkedToOosGiko"]


## COMPLETED


func oosGikoExit():
	var oosGiko = Rooms.getGikoByNpcId("outOfShapeGiko")
	## what if exit is in non continuous tile?
	var randomDoor = Rooms.getFirstWalkableDoorInRoom(oosGiko.currentTile)
	if randomDoor.size() > 0:
		var doorTile = Vector2(randomDoor["x"], randomDoor["y"])
		oosGiko.startTargetting(doorTile, 0)


## SETUP


func setup() -> void:
	## test
	NPCs.addActiveNPC("kaidan", "outOfShapeGiko", Constants.Directions.DIR_UP, Vector2(0, 5))
	NPCs.addQuestDialogue(
		"kaidan",
		"outOfShapeGiko",
		{
			"info": {"name": "oosGikoComplain", "requeue": true, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text": "[nervous]Huff...huff...just catching my breath.[/nervous]",
				"nextId": "oosGiko2"
			},
			"oosGiko2":
			{
				"id": "oosGiko2",
				"type": Constants.LineType.Text,
				"text":
				"Why are these stairs so steep? ...Even the perspective in this room is completely different.",
				"nextId": "oosGiko3"
			},
			"oosGiko3":
			{
				"id": "oosGiko3",
				"type": Constants.LineType.Choice,
				"choices":
				[
					{
						"text": '"Recently my obesity has been tough/painful..." you say....',
						"nextId": "oosGiko4"
					},
					{
						"text":
						"The stairs aren't that steep. Please move, you're blocking the way.",
						"nextId": "oosGikoEnd"
					}
				]
			},
			"oosGiko4":
			{
				"id": "oosGiko4",
				"type": Constants.LineType.Choice,
				"choices":
				[
					{
						"text": "A FATSO CAN BE CURED. Graduating from it isn\'t a dream.",
						"nextId": "oosGiko5"
					}
				]
			},
			"oosGiko5":
			{
				"id": "oosGiko5",
				"type": Constants.LineType.Text,
				"text":
				"You...You're the first person to believe in me...You're right! I'll start exercising right away!",
				"flags": [{"flag": "qTalkedToOosGiko", "type": "set", "value": true}]
			},
			"oosGikoEnd":
			{
				"id": "oosGikoEnd",
				"type": Constants.LineType.Text,
				"text": "Screw you! I'm doing my best!"
			},
		}
	)
