extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var refresh = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var NPCs = {
	"catarp" : {
		"id" : "catarp",
		"name" : "CATARP!",
		"character" : Constants.Character.Uzukumari,
		"lines" : [
			["Hey, wanna see a picture of my food?"],
			[
				"It's going to be time for basho.",
				"Here comes the old Armenian."
			],
			["Remind me to clock out in 50 minutes!"]
		]
	},
	"caribear" : {
		"id" : "caribear",
		"name" : "caribear",
		"character" : Constants.Character.Wild_Panda_Naito,
		"lines" : [
			["Let's listen to something on my turntable!"]
		]
	},
	"zzazzachu" : {
		"id" : "zzazzachu",
		"name" : "zzazzachu",
		"character" : Constants.Character.Shii_Pianica,
		"lines" : [
			[
				"I could either [nervous]propose marriage[/nervous] or take a dump on the floor in front of you.",
				"[heart]For you? I give you a sweet little kiss on the forehead![/heart]",
				"Good luck on thy travels. Return here to restore your hp by getting your dink sunked."
			],
			[
				"Just heat some oil of your choice in a pan, grit your teeth, man up, and put your hands in the oil.",
				"Leave to crisp, then crunch: battered fingers!"
			]
		]
	},
	"Muryoku" : {
		"id" : "Muryoku",
		"name" : "Muryoku",
		"character" : Constants.Character.FunkyNaito,
		"lines" : [
			[
				"[jump]I hope Japan wins the world cup this time![/jump]"
			]
		]
	},
	"Shaddox" : {
		"id" : "Shaddox",
		"name" : "Shaddox",
		"character" : Constants.Character.Hentai_Giko,
		"lines" : [
			[
				"Hello! Do you know how to play Mahjong?"
			],
		]
	},
}

var ACTIVE_NPCs = {
	"admin" : [
		{
			"id" : "catarp",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x" : 7,
			"y" : 3
		},
		{
			"id" : "caribear",
			"direction" : Constants.Directions.DIR_LEFT,
			"x" : 10,
			"y" : 3
		}
	],
	"bar" : [
		{
			"id" : "zzazzachu",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x" : 3,
			"y" : 2
		}
	],
	"izakaya774" : [
		{
			"id" : "Muryoku",
			"direction" : Constants.Directions.DIR_UP,
			"x" : 3,
			"y": 1
		}
	]
}

func removeActiveNPC(roomId : String, NPCId : String) -> void:
	if ACTIVE_NPCs.has(roomId):
		for npc in ACTIVE_NPCs[roomId]:
			if npc["id"] == NPCId:
				ACTIVE_NPCs.erase(npc)
				refresh = true
				break

func addActiveNPC(roomId : String, NPCId : String, direction : int, position : Vector2) -> void:
	if (!ACTIVE_NPCs.has(roomId)):
		ACTIVE_NPCs[roomId] = []
	ACTIVE_NPCs[roomId].push_back(
		{
			"id" : NPCId,
			"direction" : direction,
			"x" : position.x,
			"y" : position.y
		}
	)
	refresh = true
