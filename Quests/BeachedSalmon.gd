extends Quest

var quest_stages = {
    "initial":
    {
        "id": "initial",
        "condition": "needNewFish",
        "completed": "addSalmonDialogue",
        "next" : "pushSalmon1"
    },
    "pushSalmon1": {
        "id": "pushSalmon1",
        "condition": "pushedSalmon1",
        "completed": "moveSalmon1",
        "next": "pushSalmon2"
    },
    "pushSalmon2": {
        "id": "pushSalmon2",
        "condition": "pushedSalmon2",
        "completed": "moveSalmon2",
        "next": "pushSalmon3"
    },
    "pushSalmon3": {
        "id": "pushSalmon3",
        "condition": "pushedSalmon3",
        "completed": "moveSalmon3",
        "entry": "I pushed the beached salmon back into the sea! I hope he's happy there.",
        "next": "final"
    },
    "final": {"id": "final"}
}


func _init().(quest_stages):
    pass
    


## CONDITIONS


func needNewFish() -> bool:
    return Quests.QUEST_FLAGS["qSushiNeedSalmon"]

func pushedSalmon1() -> bool:
    return Quests.QUEST_FLAGS["qPushedSalmon"] > 0

func pushedSalmon2() -> bool:
    return Quests.QUEST_FLAGS["qPushedSalmon"] > 1

func pushedSalmon3() -> bool:
    return Quests.QUEST_FLAGS["qPushedSalmon"] > 2


## COMPLETED

func moveSalmon3() -> void:
    var salmon = Rooms.getGikoByNpcId("SwimmingSalmon")
    if salmon != null:
        salmon.disappear()
    NPCs.removeActiveNPC("seashore", "SwimmingSalmon")

    var floatingSalmon = {
        "url" : "res://Characters/salmon/front-standing.png",
        "world_scale" : 0.04,
        "rotation": 0,
        "block" : false,
        "offset": Vector2(50, -150)
    }
    Items.addEnvironmentItem("seashore", Vector2(0,0), floatingSalmon)
    #main.loadEnvironmentItem(Vector2(0,0), floatingSalmon)

func moveSalmon2() -> void:
    var salmon = Rooms.getGikoByNpcId("SwimmingSalmon")
    if salmon != null:
        salmon.targetTile = Vector2(0,2)
        salmon.isTargeting = true
    NPCs.updateNPCPosition("seashore", "SwimmingSalmon", Vector2(0, 2))

func moveSalmon1() -> void:
    var salmon = Rooms.getGikoByNpcId("SwimmingSalmon")
    if salmon != null:
        salmon.targetTile = Vector2(1,2)
        salmon.isTargeting = true
    NPCs.updateNPCPosition("seashore", "SwimmingSalmon", Vector2(1, 2))


func addSalmonDialogue() -> void:
    print("Added salmon dialogue")

    NPCs.addActiveNPC("seashore", "SwimmingSalmon", Constants.Directions.DIR_DOWN, Vector2(2,2))

    NPCs.addQuestDialogue(
        "seashore",
        "SwimmingSalmon",
        {
            "info": {"name": "SalmonHarvesting", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Choice,
                "choices" : [
                    {
                        "text" : "He seems to still be breathing!",
                        "nextId" : "SalmonHarvest2"
                    }
                ]
            },
            "SalmonHarvest2":
            {
                "id": "SalmonHarvest2",
                "type": Constants.LineType.Text,
                "text" : "[nervous]...Blub....Blub...[/nervous]",
                "nextId": "SalmonHarvest3"
            },
            "SalmonHarvest3" :
            {
                "id" : "SalmonHarvest3",
                "type": Constants.LineType.Choice,
                "choices" : [
                    {
                        "text": "Hmm, I still need fresh fish...That gives me an idea!",
                        "condition": {
                            "type" : Constants.ConditionType.NoFlag,
                            "value" : "qSushiNewSalmon"
                        },
                        "nextId": "SalmonSteak"
                    },
                    {
                        "text": "This poor beached Salmon. I should try to push him back into the sea. [Push]",
                        "flags": [{"flag": "qPushedSalmon", "type": "add", "value": 1}]
                    },
                    {
                        "text": "I'm sure he'll figure it out.",
                    }
                ]
                
            },
            "SalmonSteak" : {
                "id": "SalmonSteak",
                "type": Constants.LineType.Choice,
                "choices" : [
                    {
                        "text": "This is going to hurt a little. [Use Knife]",
                        "rewards" : ["salmon_steak"],
                        "condition": {
                            "type" : Constants.ConditionType.Item,
                            "value" : "chef_knife"
                        },
                        "flags": [{"flag": "qSushiNewSalmon", "type": "set", "value": true}]
                    },
                    {
                        "condition": {
                            "type" : Constants.ConditionType.Item,
                            "value" : "chef_knife"
                        },
                
                        "text": "I can't bring myself to do it...I'll find fresh fish another way!"
                    },
                    {
                        "condition": {
                            "type" : Constants.ConditionType.NoItem,
                            "value" : "chef_knife"
                        },
                        "text": "I can't do that with my hands. I need a sharp object, like a knife."
                    }
                ]
            }
        })


## SETUP
