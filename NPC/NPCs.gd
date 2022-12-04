extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
				"I could either propose marriage or take a dump on the floor in front of you.",
				"For you? I give you a sweet little kiss on the forehead!",
				"Good luck on thy travels. Return here to restore your hp by getting your dink sunked."
			],
			[
				"Just heat some oil of your choice in a pan, grit your teeth, man up, and put your hands in the oil.",
				"Leave to crisp, then crunch: battered fingers!"
			]
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
			"x" : 7,
			"y" : 3
		}
	]
}
