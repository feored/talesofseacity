extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


var NPCs = {
	"Shaddox":
	{
		"id": "Shaddox",
		"name": "Shaddox",
		"character": Constants.Character.Hentai_Giko,
		"lines":
		[
			Utils.makeSimpleDialogue([
				"Hello! Do you know how to play Mahjong?"
			])
		]
	},
	"KonbiniNPCBathroom" : {
		"id" : "KonbiniNPCBathroom",
		"name" : "IBS-kun",
		"character" : Constants.Character.Hungry_Giko,
		"lines" : [
			Utils.makeSimpleDialogue([
				"Do you mind? I'm trying to wash my hands."
			]),
			Utils.makeSimpleDialogue([
				"Go bother someone else."
			]),
			Utils.makeSimpleDialogue([
				"...Are you a pervert?"
			])
		]
	},
	"KonbiniClerk" : {
		"id" : "KonbiniClerk",
		"name" : "Clerk",
		"character" : Constants.Character.Hotsuma_Giko,
		"lines" : [
			Utils.makeSimpleDialogue([
				"How much money do you want to send to the orphanage?"
			]),
			Utils.makeSimpleDialogue([
				"I'm saving up until I can quit this job and become a NEET forever."
			]),
			Utils.makeSimpleDialogue([
				"Are you gonna buy anything?"
			])
		]
	},
	"HungryShobon" : {
		"id" : "HungryShobon",
		"name" : "Hungry Shobon",
		"character" : Constants.Character.Shobon,
		"lines" : [

		]
	},
	"YoshinoyaKopipeNPC" : {
		"id" : "YoshinoyaKopipeNPC",
		"name" : "Anonymous",
		"character" : Constants.Character.George,
		"lines" : [
			Utils.makeSimpleDialogue([
				"I went to Yoshinoya a while ago; you know, Yoshinoya?",
				"Well anyways there was an insane number of people there, and I couldn't get in.",
				"Then, I looked at the banner hanging from the ceiling, and it had \"150 yen off\" written on it.",
				"Oh, the stupidity. Those idiots.",
				"You, don't come to Yoshinoya just because it's 150 yen off, fool.",
				"It's only 150 yen, 1-5-0 YEN for crying out loud.",
				"There're even entire families here. Family of 4, all out for some Yoshinoya, huh? How fucking nice.",
				"\"Alright, daddy's gonna order the extra-large.\" God I can't bear to watch.",
				"You people, I'll give you 150 yen if you get out of those seats.",
				"Yosinoya should be a bloody place.",
				"That tense atmosphere, where two guys on opposite sides of the U-shaped table can start a fight at any time,",
				"the stab-or-be-stabbed mentality, that's what's great about this place.",
				"Women and children should screw off and stay home.",
				"Anyways, I was about to start eating, and then the bastard beside me goes \"extra-large, with extra sauce.\"",
				"Who in the world orders extra sauce nowadays, you moron?",
				"I want to ask him, \"do you REALLY want to eat it with extra sauce?\"",
				"I want to interrogate him. I want to interrogate him for roughly an hour.",
				"Are you sure you don't just want to try saying \"extra sauce\"?",
				"Coming from a Yoshinoya veteran such as myself, the latest trend among us vets is this, extra green onion.",
				"That's right, extra green onion. This is the vet's way of eating.",
				"Extra green onion means more green onion than sauce. But on the other hand the price is a tad higher. This is the key.",
				"And then, it's delicious. This is unbeatable.",
				"However, if you order this then there is danger that you'll be marked by the employees from next time on; it's a double-edged sword.",
				"I can't recommend it to amateurs.",
				"What this all really means, though, is that you should just stick with today's special."
			])
		]
	},
	"YoshinoyaCustomer" : {
		"id" : "YoshinoyaCustomer",
		"name" : "Customer",
		"character" : Constants.Character.Hungry_Giko,
		"lines" : [
			Utils.makeSimpleDialogue([
				"Just trying to eat..."
		]),
		Utils.makeSimpleDialogue([
			"Did the guy outside tell you to try extra green onion?",
			"I don't know what his problem is. You know, his story isn't even original.",
		])
		]
	},
	"Hacker" : {
		"id" : "Hacker",
		"name" : "Hacker",
		"character" : Constants.Character.Hikki,
		"lines" : [
			Utils.makeSimpleDialogue(["From the way the code is put together, I can say it's written by a woman."]),
			Utils.makeSimpleDialogue(["While I listen to music, I have the cognitive power to input that song as MP3 data."]),
			Utils.makeSimpleDialogue(["Hissatsu!! Double Compile!!"])
		]
	},
	"HamRadioEnthusiast" : {
		"id" : "HamRadioEnthusiast",
		"name" : "Ham Radio Enthusiast",
		"character" : Constants.Character.Hotsuma_Giko,
		"lines" : []
	},
	"TrainimeWatcher" : {
		"id" : "TrainimeWatcher",
		"name" : "Trainime Watcher",
		"character" : Constants.Character.NaitoApple,
		"lines" : [
			Utils.makeSimpleDialogue([
				"We're rewatching Strike Witches!"
			])
		]
	},
	"ShonenFan" : 
	{
		"id" : "ShonenFan",
		"name" : "Shonen Fan",
		"character" : Constants.Character.Baba_Shobon,
		"lines" : [
			Utils.makeSimpleDialogue([
				"Brocken Jr's troubled past makes him even more relatable! He's truly the coolest Justice Chojin!"
			])
		]
	},
	"TrainFemaleCommuter" :
	{
		"id" : "TrainFemaleCommuter",
		"name" : "Female Commuter",
		"character": Constants.Character.Shii_Uniform,
		"lines" : [
			Utils.makeSimpleDialogue([
				"I don't feel safe with all these anime weirdos around...",
				"I wish there was another train I could take..."
			])
		]
	},
	"TanningShii" :
	{
		"id" : "TanningShii",
		"name" : "Tanning Shii",
		"character" : Constants.Character.Shii,
		"lines" : []
	},
	"HilltopPervertedKid" :
	{
		"id" : "HilltopPervertedKid",
		"name" : "Perverted Kid",
		"character" : Constants.Character.Furoshiki_Shobon,
		"lines" : [Utils.makeSimpleDialogue(["Shhh! I'm gonna get caught!"])]
	},
	"HilltopBoilingSalmon" :
	{
		"id" : "HilltopBoilingSalmon",
		"name": "Boiling Salmon",
		"character" : Constants.Character.Salmon,
		"lines" : [Utils.makeSimpleDialogue(["..."])]
	},
	"Bathgoer":
	{
		"id": "Bathgoer",
		"name" : "Bathgoer",
		"character" : Constants.Character.Shii,
		"lines" : [Utils.makeSimpleDialogue(["[nervous]Ahh..nothing like a bath...[/nervous]"]),
				Utils.makeSimpleDialogue(["Did you know this used to be a way to regen MP?",
				"Apparently it was abandoned because PONOS IN VAGOO is so much more effective."])]
	},
	"SushiCustomer" : 
	{
		"id" : "SushiCustomer",
		"name" : "Old Customer",
		"character": Constants.Character.Onigiri,
		"lines" : [
			Utils.makeSimpleDialogue(["This is delicious."])
		]
	},
	"SushiChef":{
		"id" : "SushiChef",
		"name" : "Sushi Chef",
		"character": Constants.Character.Tinpopo,
		"lines" : [
			Utils.makeSimpleDialogue(["♫ Show you, show me...Kikkoman...♪"])
		]
	},
	"SushiTiredSalaryman" : 
	{
		"id" : "SushiTiredSalaryman",
		"name" : "Tired Salaryman",
		"character": Constants.Character.Tabako_Dokuo,
		"lines" : []
	},
	"BoredHostess" : 
	{
		"id" : "BoredHostess",
		"name" : "Bored Hostess",
		"character" : Constants.Character.Shiinigami,
		"lines" : []
	},
	"CrazyTrashBoon":
	{
		"id": "CrazyTrashBoon",
		"name": "Trash Boon",
		"character": Constants.Character.Naito,
		"lines": []
	},
	"WildZonu1":
	{
		"id" : "WildZonu1",
		"name": "Wild Zonu",
		"character": Constants.Character.Zonu,
		"lines" : [Utils.makeSimpleDialogue(["[nervous]Grrr...[/nervous]"])]
	},
	"WildZonu2":
	{
		"id" : "WildZonu2",
		"name": "Wild Zonu",
		"character": Constants.Character.Zonu,
		"lines" : [Utils.makeSimpleDialogue(["[nervous]Grrr...[/nervous]"])]
	},
	"WildZonu3":
	{
		"id" : "WildZonu3",
		"name": "Wild Zonu",
		"character": Constants.Character.Zonu,
		"lines" :[Utils.makeSimpleDialogue([ "[nervous]Grrr...[/nervous]"])]
	},
	"WildZonu4":
	{
		"id" : "WildZonu4",
		"name": "Wild Zonu",
		"character": Constants.Character.Zonu,
		"lines" : [Utils.makeSimpleDialogue(["[nervous]Grrr...[/nervous]"])]
	},
	"WildZonu5":
	{
		"id" : "WildZonu5",
		"name": "Wild Zonu",
		"character": Constants.Character.Zonu,
		"lines" : [Utils.makeSimpleDialogue(["[nervous]Grrr...[/nervous]"])]
	},
	"ScaredShobon":
	{
		"id" : "ScardShobon",
		"name": "Scared Shobon",
		"character": Constants.Character.Shobon,
		"lines" : []
	},
	"outOfShapeGiko": 
	{
		"id": "outOfShapeGiko",
		"name": "Out of Shape Giko",
		"character": Constants.Character.Hungry_Giko,
		"lines" : []
	},
	"Philosopher" : 
	{
		"id": "Philosopher",
		"name": "Philosopher",
		"character": Constants.Character.FunkyNaito,
		"lines" : [
			Utils.makeSimpleDialogue(["When the giko stares into the abyss, the abyss stares back into the giko."]),
			Utils.makeSimpleDialogue(["Gikos are like hedgehogs looking to huddle together for warmth on a cold day around an interesting stream.",
			"As they begin to prick one another with their quills, they are obliged to disperse."])
		]
	},
	"SwimmingSalmon" :
	{
		"id": "SwimmingSalmon",
		"name": "Beached Salmon",
		"character": Constants.Character.Salmon,
		"lines": [Utils.makeSimpleDialogue(["Blub blub."])]
	},
	"SwimmingIka" :
	{
		"id": "SwimmingIka",
		"name": "Ika",
		"character": Constants.Character.Ika,
		"lines": [Utils.makeSimpleDialogue(["Why can't I go any further than this?", "I want to go back to my people..."])]
	},
	"Commuter":
	{
		"id": "Commuter",
		"name": "Commuter",
		"character": Constants.Character.Tabako_Dokuo,
		"lines" : [
            Utils.makeSimpleDialogue(["Getting around Sea City has been a breeze since they added this train."]),
            Utils.makeSimpleDialogue(["Ever noticed that one of the stops is actually a bus stop?"])
        ]
	},
	"NewcomerGiko":
	{
		"id": "NewcomerGiko",
		"name": "Lost Newcomer",
		"character": Constants.Character.Giko,
		"lines": [
			Utils.makeSimpleDialogue(["What is this place?"]),
			Utils.makeSimpleDialogue(["I think I missed the button to register an account."]),
			Utils.makeSimpleDialogue(["How do I erase my chat bubble?"])
		]
	},
	"Scientist":
	{
		"id": "Scientist",
		"name": "Prof. Fibonacci",
		"character": Constants.Character.Tikan_Giko,
		"lines": []
	},
	"ShogiPlayer":
	{
		"id": "ShogiPlayer",
		"name": "Pointy Nosed Shogi Player",
		"character": Constants.Character.Hotsuma_Giko,
		"lines": [
			Utils.makeSimpleDialogue(["[jump]I hate it![/jump]", " [jump]I hate it![/jump]", " [jump]くやしい![/jump]"])
		]
	},
	"ShogiPlayer2":
	{
		"id": "ShogiPlayer2",
		"name": "Immature Shogi Player",
		"character": Constants.Character.Dokuo,
		"lines": [
			Utils.makeSimpleDialogue(["My real life hasn't started yet. The real me is still asleep, so that's why I'm losing."])
		]
	},
	"TeachersAssistant":
	{
		"id": "TeachersAssistant",
		"name": "Teacher's Assistant",
		"character": Constants.Character.Hotsuma_Giko,
		"lines" : []
	},
	"SiloSinger":
	{
		"id": "SiloSinger",
		"name": "Shii",
		"character": Constants.Character.Shii,
		"lines": [Utils.makeSimpleDialogue(["♪ Under the moon, loli to issho ♪"])]
	},
	"AnonymousBarman":
	{
		"id": "AnonymousBarman",
		"name": "Anonymous Barman",
		"character": Constants.Character.George,
		"lines" : []
	},
	"Policeman":
	{
		"id": "Policeman",
		"name": "Policeman",
		"character": Constants.Character.Tokita_Naito,
		"lines": [Utils.makeSimpleDialogue(["Alright, move along now..."])]
	},
	"ShiisSong":
	{
		"id": "ShiisSong",
		"name": "Shii",
		"character": Constants.Character.Shii,
		"lines": [
			Utils.makeSimpleDialogue(["Wishing on a dream that seems far off", "Hoping it will come today", "Into the starlight night, foolish dreamers turn their gaze", "Waiting on a shooting star..."])
		]
	},
	"ShiisSongHimawari":
	{
		"id":"ShiisSongHimawari",
		"name": "Sunflower",
		"character": Constants.Character.Himawari,
		"lines": [
			Utils.makeSimpleDialogue(["When the horizon darkens most", "We all need to believe there is hope..."])
		]
	},
	"Engineer1":
	{
		"id": "Engineer1",
		"name": "Engineer",
		"character": Constants.Character.Chotto_Toorimasu_Yo,
		"lines": []
	},
	"Engineer2":
	{
		"id": "Engineer2",
		"name": "Engineer",
		"character": Constants.Character.Chotto_Toorimasu_Yo,
		"lines": []
	},
	"Engineer3":
	{
		"id": "Engineer3",
		"name": "Engineer",
		"character": Constants.Character.Chotto_Toorimasu_Yo,
		"lines": []
	},
	"WellFisher":
	{
		"id": "WellFisher",
		"name": "Fisher",
		"character": Constants.Character.Wild_Panda_Naito,
		"lines": [
			Utils.makeSimpleDialogue(["♪ Fish, Fish, Fish for me, Fish, Fish, Fish for you ♫"])
		]
	},
    "FascinatedGrass":
    {
        "id": "FascinatedGrass",
        "name": "Fascinated Boon",
        "character": Constants.Character.Kaminarisama_Naito,
        "lines": [
            Utils.makeSimpleDialogue(["♪ Fish, Fish, Fish for me, Fish, Fish, Fish for you ♫"])
        ]
    },
    "TrainDrunk":
    {
        "id": "TrainDrunk",
        "name": "Violent Drunkard",
        "character" : Constants.Character.Naito_Yurei,
        "lines": []
    }

}

var ACTIVE_NPCs = {
	"admin":
	{
	},
	"admin_st":
	{
		"NewcomerGiko":
		{
			"id": "NewcomerGiko",
			"direction": Constants.Directions.DIR_UP,
			"x": 1,
			"y": 0,
			"lines": []
		},
		"ShogiPlayer":
		{
			"id": "ShogiPlayer",
			"direction": Constants.Directions.DIR_UP,
			"x": 5,
			"y": 6,
			"lines": []
		},
		"ShogiPlayer2":
		{
			"id": "ShogiPlayer2",
			"direction": Constants.Directions.DIR_DOWN,
			"x": 5,
			"y": 8,
			"lines": []
		},
	},
	"bar":
	{
	},
	"bar_st" :
	{
		"BoredHostess":
		{
			"id": "BoredHostess",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x" : 9,
			"y": 4,
			"lines" : []
		}
	},
	"izakaya774":
	{
	},
	"bar774":
	{
		"AnonymousBarman":
		{
			"id": "AnonymousBarman",
			"direction": Constants.Directions.DIR_RIGHT,
			"x": 1,
			"y": 4,
			"lines" : []
		}
	},
	"takadai":
	{
		"Shaddox":
		{
			"id": "Shaddox",
			"direction": Constants.Directions.DIR_LEFT,
			"x": 0,
			"y": 9,
			"lines": []
		},
		"HilltopPervertedKid" :
		{
			"id" : "HilltopPervertedKid",
			"direction": Constants.Directions.DIR_RIGHT,
			"x" :  5,
			"y" : 10
		},
		"HilltopBoilingSalmon":
		{
			"id" : "HilltopBoilingSalmon",
			"direction": Constants.Directions.DIR_UP,
			"x":8,
			"y":9,
			"lines": []
		},
		"Bathgoer" :
		{
			"id" : "Bathgoer",
			"direction": Constants.Directions.DIR_LEFT,
			"x":7,
			"y":9
		}
	},
	"konbini" :
	{
		"KonbiniNPCBathroom" : 
		{
			"id" : "KonbiniNPCBathroom",
			"direction" : Constants.Directions.DIR_UP,
			"x" : 0,
			"y" : 3,
			"lines": []
		},
		"KonbiniClerk": 
		{
			"id" : "KonbiniClerk",
			"direction" : Constants.Directions.DIR_DOWN,
			"x" : 6,
			"y" : 7,
			"lines": []
		}
	},
	"bar_giko_square" :
	{
		"YoshinoyaKopipeNPC" : 
		{
			"id" : "YoshinoyaKopipeNPC",
			"direction" : Constants.Directions.DIR_DOWN,
			"x" : 3,
			"y" : 12,
			"lines" : []
		},
		"HungryShobon" : 
		{
			"id" : "HungryShobon",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x" : 13,
			"y" : 11,
			"lines" : []
		},
		"Policeman":
		{
			"id": "Policeman",
			"direction": Constants.Directions.DIR_RIGHT,
			"x": 4,
			"y": 7,
			"lines" : []
		}
	},
	"yoshinoya" : 
	{
		"YoshinoyaCustomer" :
		{
			"id" : "YoshinoyaCustomer",
			"direction" : Constants.Directions.DIR_UP,
			"x" : 7,
			"y" : 2,
			"lines" : []
		}
	},
	"nerd_office" : 
	{
		"Hacker" : 
		{
			"id" : "Hacker",
			"direction" : Constants.Directions.DIR_UP,
			"x" : 3,
			"y" : 4,
			"lines" : []
		},
		"HamRadioEnthusiast" : 
		{
			"id" : "HamRadioEnthusiast",
			"direction" : Constants.Directions.DIR_LEFT,
			"x" : 1,
			"y" : 0,
			"lines" : []
		}
	},
	"densha" :
	{
		"TrainimeWatcher" : 
		{
			"id" : "TrainimeWatcher",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x": 0,
			"y": 5,
			"lines" : []
		},
		"ShonenFan" : 
		{
			"id" : "ShonenFan",
			"direction" : Constants.Directions.DIR_LEFT,
			"x": 2,
			"y": 6,
			"lines" : []
		},
		"TrainFemaleCommuter" : 
		{
			"id" : "TrainFemaleCommuter",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x": 0,
			"y": 6,
			"lines" : []
		},
		"Commuter":
		{
			"id":"Commuter",
			"direction": Constants.Directions.DIR_RIGHT,
			"x": 0,
			"y": 10,
			"lines": []
		}
	},
	"seashore" : 
	{
		"TanningShii" : 
		{
			"id" : "TanningShii",
			"direction" : Constants.Directions.DIR_LEFT,
			"x": 2,
			"y": 9,
			"lines" : []
		},
		"SwimmingSalmon":
		{
			"id": "SwimmingSalmon",
			"direction" : Constants.Directions.DIR_DOWN,
			"x": 2,
			"y": 2,
			"lines" : []
		},
		"SwimmingIka":
		{
			"id":"SwimmingIka",
			"direction": Constants.Directions.DIR_LEFT,
			"x":0,
			"y":10,
			"lines":[]
		}
	},
	"yatai" : 
	{
		"SushiCustomer":
		{
			"id" : "SushiCustomer",
			"direction": Constants.Directions.DIR_UP,
			"x": 5,
			"y": 1,
			"lines" : []
		},
		"SushiTiredSalaryman":
		{
			"id": "SushiTiredSalaryman",
			"direction": Constants.Directions.DIR_UP,
			"x": 1,
			"y": 1,
			"lines" : []
		},
		"SushiChef":{
			"id" : "SushiChef",
			"direction": Constants.Directions.DIR_DOWN,
			"x": 4,
			"y": 3,
			"lines" : []
		}
	},
	"busstop":
	{
		"CrazyTrashBoon":
		{
			"id" : "CrazyTrashBoon",
			"direction": Constants.Directions.DIR_RIGHT,
			"x": 0,
			"y": 4,
			"lines" : [Utils.makeSimpleDialogue(["[jump angle=3.141]NOW I'VE LOST IT[/jump]", "[jump angle=3.141]I KNOW I CAN KILL[/jump]", "[jump angle=3.141]DOES TRUTH EXIST BEYOND THE GATE?[/jump]"], "Crazy"),
				Utils.makeSimpleDialogue(["[jump angle=3.141]HAVE YOU READ YOUR DAILY FORCED JAPANESE FLANFLY JUMPING THROUGH HOOPS TODAY?!![/jump]"], "CrazyForced")]
		}
	},
	"school_ground":
	{
		"WildZonu1":
		{
			"id": "WildZonu1",
			"x": 4,
			"y": 3,
			"direction": Constants.Directions.DIR_UP,
			"lines" : []
		},
		"WildZonu2":
		{
			"id": "WildZonu2",
			"x": 3,
			"y": 4,
			"direction": Constants.Directions.DIR_RIGHT,
			"lines" : []
		},
		"WildZonu3":
		{
			"id": "WildZonu3",
			"x": 3,
			"y": 5,
			"direction": Constants.Directions.DIR_DOWN,
			"lines" : []
		},
		"WildZonu4":
		{
			"id": "WildZonu4",
			"x": 4,
			"y": 5,
			"direction": Constants.Directions.DIR_DOWN,
			"lines" : []
		},
		"WildZonu5":
		{
			"id": "WildZonu5",
			"x": 5,
			"y": 4,
			"direction": Constants.Directions.DIR_LEFT,
			"lines" : []
		},
		"ScaredShobon":
		{
			"id": "ScaredShobon",
			"x": 4,
			"y": 4,
			"direction":  Constants.Directions.DIR_DOWN,
			"lines" : []
		}
	},
	"silo" : 
	{
		"Philosopher":{
			"id": "Philosopher",
			"x": 0,
			"y": 4,
			"direction": Constants.Directions.DIR_LEFT,
			"lines": []
		},
		"SiloSinger":
		{
			"id": "SiloSinger",
			"x": 3,
			"y": 6,
			"direction": Constants.Directions.DIR_RIGHT,
			"lines" : []
		}
	},
	"school":
	{
		"Scientist":
		{
			"id": "Scientist",
			"x": 0,
			"y": 2,
			"direction": Constants.Directions.DIR_LEFT,
			"lines": []
		}
	},
	"idoA":
	{
		"WellFisher":
		{
			"id": "WellFisher",
			"x": 1,
			"y": 4,
			"direction": Constants.Directions.DIR_RIGHT,
			"lines": []
		},
        "FascinatedGrass":
        {
            "id": "FascinatedGrass",
            "x": 6,
            "y": 7,
            "direction": Constants.Directions.DIR_DOWN,
            "lines": []
        }
	}
}


func removeActiveNPC(roomId: String, NPCId: String) -> void:
	ACTIVE_NPCs[roomId].erase(NPCId)



func addActiveNPC(roomId: String, NPCId: String, direction: int, position: Vector2) -> void:
	if !ACTIVE_NPCs.has(roomId):
		ACTIVE_NPCs[roomId] = {}
	ACTIVE_NPCs[roomId][NPCId] = ({
		"id": NPCId, "direction": direction, "x": position.x, "y": position.y, "lines": []
	})

func addStockLine(NPCId: String, content):
	NPCs[NPCId]["lines"].push_back(content)

func updateNPCPosition(roomId: String, NPCId: String, newPosition : Vector2) -> void:
	ACTIVE_NPCs[roomId][NPCId]["x"] = newPosition.x
	ACTIVE_NPCs[roomId][NPCId]["y"] = newPosition.y

func removeQuestDialogueByName(roomId : String, NPCId : String, dialogueName : String) -> void:
	## remove old dialogue from active lines
	var dialogueIndex = 0
	var foundDialogue = false
	for i in range(ACTIVE_NPCs[roomId][NPCId]["lines"].size()):
		if (ACTIVE_NPCs[roomId][NPCId]["lines"][i]["info"]["name"] == dialogueName):
			dialogueIndex = i
			foundDialogue = true
	if foundDialogue:
		ACTIVE_NPCs[roomId][NPCId]["lines"].remove(dialogueIndex)
	else:
		print("Failed to remove dialogue %s by %s in %s." % [dialogueName, NPCId, roomId])

	
func removeAllQuestDialogue(roomId: String, NPCId : String) -> void:
	ACTIVE_NPCs[roomId][NPCId]["lines"].clear()


func addQuestDialogue(roomId : String, NPCId : String, dialogue : Dictionary) -> void:
	if (ACTIVE_NPCs.has(roomId) && ACTIVE_NPCs[roomId].has(NPCId)):
		ACTIVE_NPCs[roomId][NPCId]["lines"].push_back(dialogue)
	else:
		print("Could not add dialogue to %s in %s because ACTIVENPC was not added yet, use addActiveNPC first." % [roomId, NPCId])


func save() -> Dictionary:
	return {
		"NPCs" : NPCs,
		"ACTIVE_NPCs" : ACTIVE_NPCs
	}

func load(save : Dictionary) -> void:
	NPCs = save["NPCs"]
	ACTIVE_NPCs = save["ACTIVE_NPCs"]
