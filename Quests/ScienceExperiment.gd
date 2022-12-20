extends Quest

var quest_stages = {
	"initial":
	{
		"id": "initial",
		"condition": "talkedToScientist",
		"completed": "gotChip",
		"entry" : "I met a strange teacher in the school classroom. He gave me a data chip to insert into a machine in Silo, which should..uhh...I'm not sure what it's supposed to do.",
		"next" : "slowDownTime"
	},
	"slowDownTime":
	{
		"id": "slowDownTime",
		"condition": "insertedChip",
		"completed": "slowDownTime",
		"entry": "I inserted the chip as instructed by the professor, and it's slowed down everyone to a crawl...I don't know what the hell is going on but I should ask him to fix it.",
		"next":  "spedUpTime"
	},
	"spedUpTime":
	{
		"id": "spedUpTime",
		"condition": "insertedSecondChip",
		"completed" : "speedUpTime",
		"entry": "I inserted the second chip the professor gave me, and it just made things worse.",
		"next": "destroyMachine1"
	},
	"destroyMachine1": {
		"id": "destroyMachine1",
		"condition": "destroyedMachine1",
		"completed": "moveMachine1",
		"next": "destroyMachine2"
	},
	"destroyMachine2": {
		"id": "destroyMachine2",
		"condition": "destroyedMachine2",
		"completed": "moveMachine2",
		"next": "destroyMachine3"
	},
	"destroyMachine3": {
		"id": "destroyMachine3",
		"condition": "destroyedMachine3",
		"completed": "moveMachine3",
		"next": "final"
	},
	"final": {"id": "final"}
}

var new_machine = {
		"url" :  "res://Items/Images/machine_inserted.png",
		"world_scale" : 0.03,
		"rotation": 0,
		"block" : true,
		"offset": Vector2(0, 0)
	}


func _init().(quest_stages):
	pass


## CONDITIONS


func talkedToScientist() -> bool:
	return Quests.QUEST_FLAGS["qTalkedToScientist"]

func insertedChip() -> bool:
	return Quests.QUEST_FLAGS["qInsertedChip"]

func insertedSecondChip() -> bool:
	return Quests.QUEST_FLAGS["qInsertedSecondChip"]

func destroyedMachine1() -> bool:
	return Quests.QUEST_FLAGS["qPushedMachine"] > 0

func destroyedMachine2() -> bool:
	return Quests.QUEST_FLAGS["qPushedMachine"] > 1

func destroyedMachine3() -> bool:
	return Quests.QUEST_FLAGS["qPushedMachine"] > 2

## COMPLETED

func moveMachine3() -> void:
	Items.removeEnvironmentDialogue("silo", Vector2(6,11))
	Items.addEnvironmentDialogue("silo", Vector2(6,12), {
		"info": {"name": "MachineInsert", "requeue": true, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Text,
			"text" : "You can see the remains of the machine far below."
		}})
	self.main.removeEnvironmentItem(Vector2(6, 11))
	
	Items.removeEnvironmentItem("silo", Vector2(6, 11))
	Rooms.updateCurrentRoomWalkableTiles()

	Constants.GIKO_MOVESPEED = Constants.DEFAULT_GIKO_MOVESPEED

	self.main.dialogueManager.setLineSet(Utils.makeSimpleDialogue([
		"The machine finally tips over the edge and crashes to the ground after a very long fall."]), "")
	self.main.dialogueManager.show()
	

func moveMachine2() -> void:
	Items.removeEnvironmentDialogue("silo", Vector2(6,10))
	Items.addEnvironmentDialogue("silo", Vector2(6,11), {
		"info": {"name": "MachineInsert", "requeue": true, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Choice,
			"choices" : [
				{
					"text": "Give the machine one last push.",
					"flags" : [{"flag": "qPushedMachine", "type": "add", "value": 1}]
				},
				{
					"text": "Walk away."
				}
			]
		}})
	
	self.main.removeEnvironmentItem(Vector2(6, 10))
	self.main.replaceEnvironmentItem(Vector2(6, 11), new_machine)
	Items.removeEnvironmentItem("silo", Vector2(6, 10))
	Items.addEnvironmentItem("silo", Vector2(6, 11), new_machine)
	Rooms.updateCurrentRoomWalkableTiles()

func moveMachine1() -> void:
	Items.removeEnvironmentDialogue("silo", Vector2(6,9))
	Items.addEnvironmentDialogue("silo", Vector2(6,10), {
		"info": {"name": "MachineInsert", "requeue": true, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Choice,
			"choices" : [
				{
					"text": "Push the machine.",
					"flags" : [{"flag": "qPushedMachine", "type": "add", "value": 1}]
				},
				{
					"text": "Walk away."
				}
			]
		}})
	
	self.main.removeEnvironmentItem(Vector2(6, 9))
	self.main.replaceEnvironmentItem(Vector2(6, 10), new_machine)
	Items.removeEnvironmentItem("silo", Vector2(6, 9))
	Items.addEnvironmentItem("silo", Vector2(6, 10), new_machine)
	Rooms.updateCurrentRoomWalkableTiles()

func speedUpTime() -> void:
	Constants.GIKO_MOVESPEED = Constants.FAST_GIKO_MOVESPEED
	NPCs.addQuestDialogue(
		"school",
		"Scientist",
		{
			"info": {"name": "ScientistIntro", "requeue": false, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text":
				"...",
				"nextId": "ScientistIntro2"
			},
			"ScientistIntro2":
			{
				"id": "ScientistIntro2",
				"type": Constants.LineType.Choice,
				"choices":  [
					{
						"text": "...",
						"nextId": "ScientistIntro3"
					}
				]
			},
			"ScientistIntro3":
			{
				"id": "ScientistIntro3",
				"type": Constants.LineType.Text,
				"text": "I'll definitely get it right next time, though!",
				"nextId": "ScientistIntro4"
			},
			"ScientistIntro4":
			{
				"id": "ScientistIntro4",
				"type": Constants.LineType.Text,
				"text": "Look, if you're not going to help, get out of the way. I'll call for you when I have a new cartridge ready."
			}
		})
	
	NPCs.addActiveNPC("school_rouka", "TeachersAssistant", Constants.Directions.DIR_LEFT, Vector2(1, 5))
	NPCs.addQuestDialogue("school_rouka", "TeachersAssistant", Utils.makeSimpleDialogue(["The professor has instructed you to take a new cartridge to the machine, right?",
	"He used to be a respectable teacher, but his students kept pestering him. They'd ask him to \"fix it\" every time something went wrong.",
	"He built that machine in response. He thought that if the students liked to complain so much, he could at least give them a valid reason to be complaining.", 
	"Ever since the professor built that machine, our students have been failing all their exams.", "It's very difficult to focus on your studies when the fabric of time is being ripped apart by your homeroom teacher.",
	"Anyway, please destroy that machine. I don't care how. For all our sakes."]))

	Items.removeEnvironmentDialogue("silo", Vector2(6,9))
	Items.addEnvironmentDialogue("silo", Vector2(6,9), {
		"info": {"name": "MachineInsert", "requeue": true, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Choice,
			"choices" : [
				{
					"text": "Push the machine.",
					"flags" :  [{"flag": "qPushedMachine", "type": "add", "value": 1}]
				},
				{
					"text": "Walk away."
				}
			]
		}})

func slowDownTime() -> void:
	Constants.GIKO_MOVESPEED = Constants.SLOW_GIKO_MOVESPEED
	
	self.main.replaceEnvironmentItem(Vector2(6,9), new_machine)
	Items.BACKGROUND_ENVIRONMENT["silo"][Vector2(6,9)] = new_machine
	Items.removeEnvironmentDialogue("silo", Vector2(6,9))
	Items.addEnvironmentDialogue("silo", Vector2(6,9),
		{
		"info": {"name": "MachineInsert", "requeue": true, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Text,
			"text":
			"The mysterious machine has gone quiet. A disk has been inserted.",
			"nextId": "MachineInsert2"
		},
		"MachineInsert2":
		{
			"id": "MachineInsert2",
			"type": Constants.LineType.Choice,
			"choices" : [
				{
					"text" : "Insert the new data chip.",
					"condition" : {"type" : Constants.ConditionType.Item, "value": "data_chip_2"},
					"nextId" : "MachineInsert3"
				},
				{
					"text": "Keep your distance."
				}
			]
		},
		"MachineInsert3":
		{
			"id": "MachineInsert3",
			"type": Constants.LineType.Text,
			"text":
			"The mysterious machine has gone quiet again. Did the cartridge work this time?",
			"costs" : ["data_chip_2"],
			"flags" : [{"flag": "qInsertedSecondChip", "type": "set", "value": true}]
		}
		}
	)
	NPCs.removeAllQuestDialogue("school", "Scientist")
	NPCs.addQuestDialogue(
		"school",
		"Scientist",
		{
			"info": {"name": "ScientistIntro", "requeue": false, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text":
				"Oh, it's you again. You may not have noticed it since you were slow to begin with, but the machine has messed up the flow of time.",
				"nextId": "ScientistIntro2"
			},
			"ScientistIntro2":
			{
				"id": "ScientistIntro2",
				"type": Constants.LineType.Choice,
				"choices": [
					{
						"text": "What the hell is that machine? What did you make me do?",
						"nextId": "ScientistIntro3"
					}
				]
			},
			"ScientistIntro3":
			{
				"id": "ScientistIntro3",
				"type": Constants.LineType.Text,
				"text":
				"Now, now...it'd take too long to explain to you. Especially now. Hehe.",
				"nextId": "ScientistIntro4"
			},
			"ScientistIntro4" :
			{
				"id": "ScientistIntro4",
				"type": Constants.LineType.Text,
				"text":
				"Ahem. Anyway, I've gone over my notes again and I believe I spotted the error. A silly off-by-1 mistake! Here, this new data chip should fix everything.",
				"rewards" : ["data_chip_2"]    
			}
		}
	)

func gotChip() -> void:
	NPCs.removeAllQuestDialogue("school", "Scientist")
	NPCs.addQuestDialogue("school", "Scientist", Utils.makeSimpleDialogue(["You're still here?!"]))
	NPCs.addQuestDialogue("school", "Scientist", Utils.makeSimpleDialogue(["My grandfather Fred Edison gave me the idea for this chip."]))
	Items.removeEnvironmentDialogue("silo", Vector2(6,9))
	Items.addEnvironmentDialogue("silo", Vector2(6,9),
		{
		"info": {"name": "MachineInsert", "requeue": true, "start": "start"},
		"start":
		{
			"id": "start",
			"type": Constants.LineType.Text,
			"text":
			"This futuristic-looking machine has many buttons and levers. It's buzzing as if in operation, but it doesn't appear to have any power cable attached.",
			"nextId": "MachineInsert2"
		},
		"MachineInsert2":
		{
			"id": "MachineInsert2",
			"type": Constants.LineType.Choice,
			"choices":
			[
				{
					"text": "Insert the data chip.",
					"costs": ["data_chip"],
					"nextId": "MachineInsert3"
				},
				{
					"text": "Turn 360° and walk away.",
				}
			]
		},
		"MachineInsert3": {
			"id": "MachineInsert3",
			"type": Constants.LineType.Text,
			"text":
			"The machine emits a high-pitched buzzing noise as if it's processing a large operation.",
			"nextId": "MachineInsert4"
		},
		"MachineInsert4": {
			"id": "MachineInsert4",
			"type": Constants.LineType.Text,
			"text":
			"Finally, the machine begins to wind down. Something seems different in the air.",
			"flags": [{"flag": "qInsertedChip", "type": "set", "value": true}]
		}
		})
## SETUP

func setup() -> void:

	NPCs.addQuestDialogue(
		"school",
		"Scientist",
		{
			"info": {"name": "ScientistIntro", "requeue": true, "start": "start"},
			"start":
			{
				"id": "start",
				"type": Constants.LineType.Text,
				"text":
				"Watch out! I almost spilled some of that chemical X on you!",
				"nextId": "ScientistIntro2"
			},
			"ScientistIntro2":
			{
				"id": "ScientistIntro2",
				"type": Constants.LineType.Text,
				"text":
				"Hmm...You look like the sort that needs extra credit.",
				"nextId": "ScientistIntro3"
			},
			"ScientistIntro3":
			{
				"id": "ScientistIntro3",
				"type": Constants.LineType.Text,
				"text":
				"Anyway, I think I've made a breakthrough with my equations! Say, would you be willing to help me with an important experiment?",
				"nextId": "ScientistIntro4"
			},
			"ScientistIntro4" :
			{
				"id": "ScientistIntro4",
				"type": Constants.LineType.Choice,
				"choices": [
					{
						"text": "Sure.",
						"flags": [{"flag": "qTalkedToScientist", "type": "set", "value": true}],
						"nextId" : "ScientistIntro5"
					},
					{
						"text": "...Did you just call me stupid?"
					}
				]
			},
			"ScientistIntro5" : {
				"id": "ScientistIntro5",
				"type": Constants.LineType.Text,
				"text":
				"Very good! Take this data chip containing instructions to alter the PSI waves that radiate around Sea City, thereby modifying the spinning coefficient.",
				"rewards" : ["data_chip"],
				"nextId": "ScientistIntro6"
			},
			"ScientistIntro6" : {
				"id": "ScientistIntro6",
				"type": Constants.LineType.Text,
				"text":
				"Insert it into the machine at Silo. Yeah, that should do it. Probably."
			}
		}
	)
	
