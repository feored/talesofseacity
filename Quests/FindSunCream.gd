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


func talkedTotanningShii() -> bool:
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
                "nextId": "HungryShobonCorndog"
            },
            "HungryShobonCorndog":
            {
                "id": "HungryShobonCorndog",
                "type": Constants.LineType.Text,
                "text":
                "I just hope I don't get a sunburn...",
                "nextId": "HungryShobonCorndog2"
            },
            "HungryShobonCorndog2":
            {
                "id": "HungryShobonCorndog2",
                "type": Constants.LineType.Text,
                "text" : "You wouldn't happen to have any sun cream on you?",
                "flags": [{"flag": "qTalkedToTanningShii", "type": "set", "value": true}]
            }
        }
    )
