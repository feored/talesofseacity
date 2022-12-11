extends Quest

var quest_stages = {
    "initial":
    {
        "id": "initial",
        "condition": "talkedToHungryShobon",
        "completed": "addClerkCorndogDialogue",
        "next" : "final"
    },
    "final": {"id": "final"}
}


func _init().(quest_stages):
    pass


## CONDITIONS


func talkedToHungryShobon() -> bool:
    return Quests.QUEST_FLAGS["qHungryCorndogTalked"]



## COMPLETED

func addClerkCorndogDialogue() -> void:
    NPCs.addQuestDialogue(
        "konbini",
        "KonbiniClerk",
        {
            "info": {"name": "KonbiniClerkCantBuyCorndog", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text":
                "Welcome! Can I get you anything?",
                "nextId": "HungryShobonCorndog"
            },
            "HungryShobonCorndog":
            {
                "id": "HungryShobonCorndog",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "I'd like a corndog, please.",
                        "nextId": "HungryShobonPay"
                    },
                    {
                        "text": "No, thanks."
                    }
                ],
                "nextId": "HungryShobonCorndog2"
            },
            "HungryShobonPay" : {
                "id": "HungryShobonPay",
                "type": Constants.LineType.Text,
                "text":
                "That'll be 1 gikocoin, sir.",
                "nextId" : "HungryShobonNoMoney1"
            },
            "HungryShobonNoMoney1":
            {
                "id": "HungryShobonNoMoney1",
                "type": Constants.LineType.Text,
                "text" : "...",
                "nextId" : "HungryShobonNoMoney2"
            },
            "HungryShobonNoMoney2":
            {
                "id": "HungryShobonNoMoney2",
                "type": Constants.LineType.Text,
                "text" : "Feel free to come back when you have some money!",
            },
        })


## SETUP

func setup() -> void:
    NPCs.addQuestDialogue(
        "bar_giko_square",
        "HungryShobon",
        {
            "info": {"name": "HungryShobonIntro", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text":
                "[nervous scale=1.0 freq=8.0]I'm so hungry...My stomach has been rumbling for days..[/nervous]",
                "nextId": "HungryShobonCorndog"
            },
            "HungryShobonCorndog":
            {
                "id": "HungryShobonCorndog",
                "type": Constants.LineType.Text,
                "text":
                "Oh...My friend sent me a photo of herself eating a corndog on route 66...",
                "nextId": "HungryShobonCorndog2"
            },
            "HungryShobonCorndog2":
            {
                "id": "HungryShobonCorndog2",
                "type": Constants.LineType.Text,
                "text" : "What I wouldn't give for a corndog right now...",
                "flags": [{"flag": "qHungryCorndogTalked", "type": "set", "value": true}]
            }
        }
    )
