extends Node


var PAUSE = false



var NAME = "Anonymous"
var SETUP_QUESTS = true
var GIKO_MOVESPEED = Constants.DEFAULT_GIKO_MOVESPEED
var BLACKOUT = false


func save() -> Dictionary:
    return {
        "NAME" : NAME, 
        "SETUP_QUESTS" : SETUP_QUESTS,
        "GIKO_MOVESPEED" : GIKO_MOVESPEED,
        "BLACKOUT" : BLACKOUT
    }

func load(save : Dictionary) -> void:
    NAME = save["NAME"]
    SETUP_QUESTS = save["SETUP_QUESTS"]
    GIKO_MOVESPEED = save["GIKO_MOVESPEED"]
    BLACKOUT = save["BLACKOUT"]
