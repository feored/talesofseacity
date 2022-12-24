extends Quest

var quest_stages = {
	"initial":
	{
		"id": "initial",
		"condition": "talkedToBarman",
		"completed": "earthquake",
		"entry" : "I was talking to the barman in Bar774 when an earthquake hit Sea City!",
		"next" : "lookingForWrench"
	},
	"lookingForWrench": 
	{
		"id": "lookingForWrench",
		"condition": "askedForWrench",
		"completed": "startFleeing",
		"entry": "I asked one of the engineers to give me their wrench so that the wind turbine could be fixed, but they're not giving it back... I think I have to catch them now.",
		"next": "gotWrench"
	},
	"gotWrench": 
	{
		"id": "gotWrench",
		"condition": "gotWrench",
		"completed" : "stopFleeing",
		"entry": "I caught the engineer. I should return the wrench to the engineer that's actually trying to fix the turbine now.",
		"next": "final"
	},
	"final": {"id": "final"}
}

func _init().(quest_stages):
	pass


## CONDITIONS

func gotWrench() -> bool:
	return Items.INVENTORY.has("wrench")

func askedForWrench() -> bool:
	return Quests.QUEST_FLAGS["qAskedForWrench"]

func talkedToBarman() -> bool:
	return Quests.QUEST_FLAGS["qTalkedToBarman"]


## COMPLETED

func stopFleeing():
	var fleeingEngineer = Rooms.getGikoByNpcId("Engineer2")
	fleeingEngineer.stopFleeing()

func startFleeing():
	NPCs.removeAllQuestDialogue("silo", "Engineer2")
	NPCs.addQuestDialogue("silo", "Engineer2", {
		"info": {"name": "PolicemanIntro", "requeue": false, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Text,
			"text": "Alright, you got me. Here's the stupid wrench.",
			"rewards" : ["wrench"]
		}})
	var fleeingEngineer = Rooms.getGikoByNpcId("Engineer2")
	fleeingEngineer.startFleeing(self.main.playerGiko)

func earthquake():
	Settings.BLACKOUT = true
	QuestUtils.earthquake()
	NPCs.addStockLine("AnonymousBarman", Utils.makeSimpleDialogue(["This isn't gonna be good for business..."]))
	NPCs.addQuestDialogue("bar_giko_square", "Policeman", 
	{
		"info": {"name": "PolicemanIntro", "requeue": false, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Choice,
			"choices" : [
				{
					"text": "Do you know what's going on?",
					"nextId": "PolicemanIntro2"
				}
			]
		},
		"PolicemanIntro2":
		{
			"id": "PolicemanIntro2",
			"type":  Constants.LineType.Text,
			"text": "Apparently, the earthquake caused some damage to the generators over at the silo.",
			"nextId": "PolicemanIntro3"
		},
		"PolicemanIntro3":
		{
			"id": "PolicemanIntro3",
			"type":  Constants.LineType.Text,
			"text": "I'm just trying to calm people down here and checking that everyone's alright after the earthquake, so I can't go help out there.",
			"nextId": "PolicemanIntro4"
		},
		"PolicemanIntro4":
		{
			"id": "PolicemanIntro4",
			"type":  Constants.LineType.Text,
			"text": "Could you maybe go and try to bring the power back? Here, take this flashlight, you'll need it.",
			"rewards": ["flashlight"]
		}
	}
	)

	NPCs.addActiveNPC("silo", "Engineer1", Constants.Directions.DIR_UP, Vector2(8,9))
	NPCs.addActiveNPC("silo", "Engineer2", Constants.Directions.DIR_DOWN, Vector2(8,10))
	NPCs.addActiveNPC("kaidan", "Engineer3", Constants.Directions.DIR_RIGHT, Vector2(5,2))

	NPCs.addQuestDialogue("silo", "Engineer1", Utils.makeSimpleDialogue(["The wind turbine seems to have been damaged by the earthquake.", "The other engineers will take care of this."]))
	NPCs.addQuestDialogue("silo", "Engineer2",  {
		"info": {"name": "EngineerIntro", "requeue": false, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Text,
			"text":
			"Maybe that other guy down the stairs will know what to do.",
			"nextId"  : "EngineerIntro2"
		},
		"EngineerIntro2":
		{
			"id": "EngineerIntro2",
			"type":  Constants.LineType.Choice,
			"choices": [
				{
					"text": "Do you have a wrench?",
					"nextId": "EngineerIntro3",
					"condition": { "type" : Constants.ConditionType.Flag, "value": "qTalkedToEngineer"}
				},
				{
					"text": "Good luck."
				}
			]
		},
		"EngineerIntro3":
		{
			"id": "EngineerIntro3",
			"type":  Constants.LineType.Text,
			"text": "Sorry, I can't give it to you. BLABLABLA",
			"flags" : [{"flag" : "qAskedForWrench", "type": "set", "value" : true}],
		}
	})
	NPCs.addQuestDialogue("kaidan", "Engineer3", {
		"info": {"name": "EngineerIntro", "requeue": false, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Text,
			"text":
			"The wind turbine needs to be repaired, but I can't count on my colleagues.",
			"nextId"  : "EngineerIntro2"
		},
		"EngineerIntro2":
		{
			"id": "EngineerIntro2",
			"type":  Constants.LineType.Text,
			"text": "I gave one of them the wrench I need to fix it, but they won't give it back. They get paid by the hour, you see.",
			"nextId": "EngineerIntro3"
		},
		"EngineerIntro3":
		{
			"id": "EngineerIntro3",
			"type":  Constants.LineType.Text,
			"text": "Anyway, could you please go and grab it for me?",
			"flags": [{"flag" : "qTalkedToEngineer", "type": "set", "value" : true}]
		}
	})

   


## SETUP

func setup() -> void:
	## test
	NPCs.addQuestDialogue(
		"bar774",
		"AnonymousBarman",
		{
			"info": {"name": "BarmanIntro", "requeue": false, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text":
				"Welcome, sir. I'm afraid we only serve anony--",
				"flags": [{"flag" : "qTalkedToBarman", "type": "set", "value" : true}],
				"nextId"  : "BarmanIntro2"
			},
			"BarmanIntro2":
			{
				"id": "BarmanIntro2",
				"type":  Constants.LineType.Text,
				"text": "[jump]Aaaaaaaah![/jump] [jump timeoffset=0.5]Earthquake!![/jump] Everyone, hide under the counter!",
				"nextId": "BarmanIntro3"
			},
			"BarmanIntro3":
			{
				"id": "BarmanIntro3",
				"type":  Constants.LineType.Text,
				"text": "I-is it over? Is everyone safe and sound?",
				"nextId": "BarmanIntro4"
			},
			"BarmanIntro4":
			{
				"id": "BarmanIntro4",
				"type":  Constants.LineType.Text,
				"text": "Looks like the power went out...What a mess! Someone needs to inform the police in Fountain Plaza."
			}
		}
		
	)
	
