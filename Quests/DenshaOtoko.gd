extends Quest

var quest_stages = {
	"initial":
	{
		"id": "initial",
		"condition": "enteredTrain",
		"condition_type": Quests.QuestConditionType.Room,
		"completed": "drunkEnter",
		"entry":
		"I entered the train and witnessed a drunk man assault a young lady. Perhaps it's time to step in.",
		"next": "altercation"
	},
	"altercation":
	{
		"id": "initial",
		"condition": "test",
		"condition_type": Quests.QuestConditionType.Flag,
		"completed": "drunkEnter",
		"entry": "I was talking to the barman in Bar774 when an earthquake hit Sea City!",
		"next": "final"
	},
	"final": {"id": "final"}
}


func _init().(quest_stages):
	pass


## CONDITIONS


func enteredTrain() -> bool:
	return Rooms.currentRoomId == "densha"


func test() -> bool:
	return false


## COMPLETED


func drunkEnter():
	NPCs.addActiveNPC("densha", "TrainDrunk", Constants.Directions.DIR_RIGHT, Vector2(0, 12))
	var trainDrunk = SceneTransition.currentGame.spawnActionQueueGiko(
		NPCs.ACTIVE_NPCs["densha"]["TrainDrunk"]
	)
	trainDrunk.addMultipleActions(
		[
			{"type": Constants.Actions.MOVE, "isTimed": false, "target": Vector2(1, 6)},
			{"type": Constants.Actions.FACE, "isTimed": false, "target": Constants.Directions.DIR_LEFT},
			{
				"type": Constants.Actions.TALK,
				"isTimed": true,
				"maxTime": 5,
				"target": "Wow, ain'tcha a cutie! Wanna come to my place?"
			},
			{
				"type": Constants.Actions.TALK,
				"isTimed": true,
				"maxTime": 5,
				"target": "Whaddaya say? Hey, look at me, bitch!"
			}
		]
	)

	var harassedGirl = Rooms.getGikoByNpcId("TrainFemaleCommuter")
	harassedGirl.faceDirection(Constants.Directions.DIR_RIGHT)

	NPCs.addQuestDialogue(
		"densha",
		"TrainDrunk",
		{
			"info": {"name": "TrainDrunkPissOff", "requeue": false, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text": "Mind your own business! I'm putting the moves on this girl here!",
				"nextId": "TrainDrunk2"
			},
			"TrainDrunk2":
			{
				"id": "BarmanIntro2",
				"type": Constants.LineType.Text,
				"text": "[nervous]What, you got a problem? You wanna be a hero?[/nervous]"
			}
		}
	)

	NPCs.addQuestDialogue(
		"densha",
		"TrainFemaleCommuter",
		{
			"info": {"name": "TrainFemaleCommuter", "requeue": false, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text": "Help! I'm so scared!",
			}
		}
	)


## SETUP


func setup() -> void:
	## test
	pass
