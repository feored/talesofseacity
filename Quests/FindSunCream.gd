extends Quest

var quest_stages = {
    "initial":
    {
        "id": "initial",
        "condition": "talkedToTanningShii",
        "next" : "final"
    },
    "final": {"id": "final"}
}


func _init().(quest_stages):
    pass


## CONDITIONS


func talkedToTanningShii() -> bool:
    return Quests.QUEST_FLAGS["qTalkedToTanningShii"]



## COMPLETED


## SETUP

func setup() -> void:
    NPCs.addQuestDialogue(
        "seashore",
        "TanningShii",
        {
            "info": {"name": "TanningShiiIntro", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text":
                "Such a lovely day! So warm and sunny!",
                "nextId": "TanningShii2"
            },
            "TanningShii2":
            {
                "id": "HungryShobonCorndog",
                "type": Constants.LineType.Text,
                "text":
                "I just hope I don't get a sunburn...",
                "nextId": "TanningShii3"
            },
            "TanningShii3":
            {
                "id": "TanningShii3",
                "type": Constants.LineType.Text,
                "text" : "You wouldn't happen to have any sun cream on you?",
                "flags": [{"flag": "qTalkedToTanningShii", "type": "set", "value": true}]
            }
        }
    )
