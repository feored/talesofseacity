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
	}

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
			"lines": []
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
			"lines": []
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
			 "lines": []
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
		"HungryShobon" : 
		{
			"id" : "HungryShobon",
			"direction" : Constants.Directions.DIR_RIGHT,
			"x" : 13,
			"y" : 11,
			"lines" : []
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
		"id": NPCId, "direction": direction, "x": position.x, "y": position.y, "lines": []
	})
	refresh = true

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


func addQuestDialogue(roomId : String, NPCId : String, dialogue : Dictionary) -> void:
	if (ACTIVE_NPCs.has(roomId) && ACTIVE_NPCs[roomId].has(NPCId)):
		ACTIVE_NPCs[roomId][NPCId]["lines"].push_back(dialogue)
	else:
		print("Could not add dialogue to %s in %s because ACTIVENPC was not added yet, use addActiveNPC first." % [roomId, NPCId])
