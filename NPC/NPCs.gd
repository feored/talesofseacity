extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var refresh = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


var NPCs = {
	"catarp":
	{
		"id": "catarp",
		"name": "CATARP!",
		"character": Constants.Character.Uzukumari,
		"lines":
		[
			Utils.makeSimpleDialogue(["Hey, wanna see a picture of my food?"]),
			Utils.makeSimpleDialogue(["It's going to be time for basho.", "Here comes the old Armenian."]),
			Utils.makeSimpleDialogue(["Remind me to clock out in 50 minutes!"])
		]
	},
	"caribear":
	{
		"id": "caribear",
		"name": "caribear",
		"character": Constants.Character.Wild_Panda_Naito,
		"lines": [
            Utils.makeSimpleDialogue(["Let's listen to something on my turntable!"])
        ]
	},
	"zzazzachu":
	{
		"id": "zzazzachu",
		"name": "zzazzachu",
		"character": Constants.Character.Shii_Pianica,
		"lines":
		[
			Utils.makeSimpleDialogue([
				"I could either [nervous]propose marriage[/nervous] or take a dump on the floor in front of you.",
				"[heart]For you? I give you a sweet little kiss on the forehead![/heart]",
				"Good luck on thy travels. Return here to restore your hp by getting your dink sunked."
			]),
			Utils.makeSimpleDialogue([
				"Just heat some oil of your choice in a pan, grit your teeth, man up, and put your hands in the oil.",
				"Leave to crisp, then crunch: battered fingers!"
			])
		]
	},
	"Muryoku":
	{
		"id": "Muryoku",
		"name": "Muryoku",
		"character": Constants.Character.FunkyNaito,
		"lines": [Utils.makeSimpleDialogue(["[jump]I hope Japan wins the world cup this time![/jump]"])]
	},
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
}

var ACTIVE_NPCs = {
	"admin":
	{
		"catarp":
		{"id": "catarp", "direction": Constants.Directions.DIR_RIGHT, "x": 7, "y": 3, "qLines": []},
		"caribear":
		{
			"id": "caribear",
			"direction": Constants.Directions.DIR_LEFT,
			"x": 10,
			"y": 3,
			"qLines": []
		}
	},
	"bar":
	{
		"zzazzachu":
		{
			"id": "zzazzachu",
			"direction": Constants.Directions.DIR_RIGHT,
			"x": 3,
			"y": 2,
			"qLines": []
		}
	},
	"izakaya774":
	{
		"Muryoku":
		{
			"id": "Muryoku", 
			"direction": Constants.Directions.DIR_UP,
			 "x": 3, 
			 "y": 1, 
			 "qLines": []
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
			"lines":
			[
				{
					"info" : {
                        "name" : "shaddoxTilesIntro",
						"requeue" : true,
                        "start" : "start"
					},
					"start" : {
						"id" : "start",
						"type" : Constants.LineType.Text,
						"text": "Hello there! I enjoy playing Mahjong, but I seem to have lost my mahjong tiles. I've looked everywhere...I don't know where I dropped them.",
						"nextId" : "ShaddoxTile2"
					},
					"ShaddoxTile2" : {
						"id" : "ShaddoxTile2",
						"type" : Constants.LineType.Text,
						"text" : "Specifically, I'm missing all three of the dragon tiles. The Red, White and Green Dragons. Could you help me look for them?",
						"nextId" : "ShaddoxTile3"
					},
					"ShaddoxTile3" : {
						"id" : "ShaddoxTile3",
						"type" : Constants.LineType.Choice,
						"choices" : [
							{
								"text" : "Sure!",
								"flags" : [
									{
										"flag": "qHelpShaddoxLookForTiles",
										"type": "set",
										"value": true
									}
								],
								"nextId" : "ShaddoxTile4"
							},
							{
								"text" : "Sorry, maybe later.",
								"flags" : [
									{
										"flag": "qHelpShaddoxLookForTiles",
										"type": "set",
										"value": false
									}
								]
							}
						   
						]
					},
					"ShaddoxTile4" :{
						"id" : "ShaddoxTile4",
						"type" : Constants.LineType.Text,
						"text" : "God bless you!"
					}
				}
			]
		}
	}
}


func removeActiveNPC(roomId: String, NPCId: String) -> void:
	if ACTIVE_NPCs.has(roomId):
		for npc in ACTIVE_NPCs[roomId]:
			if npc["id"] == NPCId:
				ACTIVE_NPCs.erase(npc)
				refresh = true
				break


func addActiveNPC(roomId: String, NPCId: String, direction: int, position: Vector2) -> void:
	if !ACTIVE_NPCs.has(roomId):
		ACTIVE_NPCs[roomId] = {}
	ACTIVE_NPCs[roomId][NPCId] = ({
		"id": NPCId, "direction": direction, "x": position.x, "y": position.y, "qLines": []
	})
	refresh = true
