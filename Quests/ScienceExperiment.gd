extends Quest

var quest_stages = {
	"initial":
	{
		"id": "initial",
		"condition": "talkedToScientist",
		"completed": "gotChip",
		"entry" : "I met a scientist in the school classroom. He gave me a data chip to insert into a machine in Silo, which should..uhh...I'm not sure what it's supposed to do.",
		"next" : "final"
	},
	"final": {"id": "final"}
}


func _init().(quest_stages):
	pass


## CONDITIONS


func talkedToScientist() -> bool:
	return Quests.QUEST_FLAGS["qTalkedToScientist"]



## COMPLETED

func gotChip() -> void:
	NPCs.removeAllQuestDialogue("school", "Scientist")
	NPCs.addQuestDialogue("school", "Scientist", Utils.makeSimpleDialogue(["You're still here?!"]))
	NPCs.addQuestDialogue("school", "Scientist", Utils.makeSimpleDialogue(["My grandfather Fred Edison gave me the idea for this chip."]))
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
				"Watch out! I almost spilled some of that horniness serum on you!",
				"nextId": "ScientistIntro2"
			},
			"ScientistIntro2":
			{
				"id": "ScientistIntro2",
				"type": Constants.LineType.Text,
				"text":
				"Hmm...You look a bit old to be a student here.",
				"nextId": "ScientistIntro3"
			},
			"ScientistIntro3":
			{
				"id": "ScientistIntro3",
				"type": Constants.LineType.Text,
				"text":
				"Anyway, I think I've made a breakthrough with my equations here! Say, would you be willing to help me with an important experiment?",
				"nextId": "ScientistIntro4"
			},
			"ScientistIntro4" :
			{
				"id": "ScientistIntro4",
				"type": Constants.LineType.Choice,
				"choices": [
					{
						"text": "Okay. Please just get that weird-looking fluid away from me.",
						"flags": [{"flag": "qTalkedToScientist", "type": "set", "value": true}],
						"nextId" : "ScientistIntro5"
					},
					{
						"text": "No thank you. Are you really allowed to teach here?"
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
	
