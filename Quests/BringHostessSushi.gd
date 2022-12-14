extends Quest

var quest_stages = {
    "initial":
    {
        "id": "initial",
        "condition": "talkedToSushiSalaryman",
        "next" : "final"
    },
    "talkToHostess" :{
       "id" : "talkToHostess",
       "condition" : "talkedToHostess",
       "next" : "final"
    },
    "final": {"id": "final"}
}


func _init().(quest_stages):
    pass


## CONDITIONS


func talkedToSushiSalaryman() -> bool:
    return Quests.QUEST_FLAGS["qTalkedToSushiSalaryman"]

func talkedToHostess() -> bool:
    return Quests.QUEST_FLAGS["qTalkedToHostess"]


## COMPLETED


## SETUP

func setup() -> void:
    NPCs.addQuestDialogue(
        "yatai",
        "SushiTiredSalaryman",
        {
            "info": {"name": "SushiTiredSalarymanIntro", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text":
                "I'm so tired...I couldn't leave until my boss did, and he was having an affair...",
                "nextId": "SushiTiredSalaryman2"
            },
            "SushiTiredSalaryman2":
            {
                "id": "HungryShobonCorndog",
                "type": Constants.LineType.Text,
                "text":
                "I just want some entertainment before I go home, but this place is dead.",
                "flags": [{"flag": "qTalkedToSushiSalaryman", "type": "set", "value": true}]
            }
        }
    )

    NPCs.addQuestDialogue(
        "bar_st",
        "BoredHostess",
        {
            "info": {"name" : "BoredHostessIsBored", "requeue" : true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text":
                "I want to move to Tokyo, but I'm stuck in this boring town.",
                "nextId": "BoredHostess2"
            },
            "BoredHostess2":
            {
                "id": "BoredHostess2",
                "type": Constants.LineType.Text,
                "text":
                "A girl like me is just never gonna make it big in a place like Sea City!",
                "nextId" : "BoredHostess3"
            },
            "BoredHostess3" :
            {
                "id": "BoredHostess3",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "If you want to move, you have to make some money first.",
                        "condition": {
                            "type" : Constants.ConditionType.Flag,
                            "value" : "qTalkedToSushiSalaryman"
                        },
                        "nextId": "BoredHostess4"
                    },
                    {
                        "text": "Well, good luck."
                    }
                ],
            },
            "BoredHostess4" :
            {
                "id": "BoredHostess4",
                "type": Constants.LineType.Text,
                "text":
                "Well, what are you saying?",
                "nextId" : "BoredHostess5"
            },
            "BoredHostess5" :
            {
                "id": "BoredHostess5",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "I know a guy who could use some entertainment at the Sushi place.",
                        "nextId": "BoredHostess6"
                    },
                    {
                        "text": "Nevermind."
                    }
                ],
            },
            "BoredHostess6" :
            {
                "id": "BoredHostess6",
                "type": Constants.LineType.Text,
                "text":
                "Hah! Only old geezers eat there! No way!",
                "nextId" : "BoredHostess7"
            },
            "BoredHostess7" :
            {
                "id": "BoredHostess7",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "Actually, there's an exciting new chef there! It's a really trendy place now.",
                        "condition": {
                            "type" : Constants.ConditionType.Flag,
                            "value" : "qSushiNewChef"
                        },
                        "nextId": "BoredHostess8"
                    },
                    {
                        "text": "..."
                    }
                ],
            },
            "BoredHostess8":
            {
                "id": "BoredHostess8",
                "type": Constants.LineType.Text,
                "text":
                "Oh ho! In that case, why not whore ourselves? I'll be right there. ",
                "nextId" : "BoredHostess7"
            }

        })

    NPCs.addQuestDialogue(
        "yatai",
        "SushiCustomer",
        {
        "info": {"name" : "SushiCustomerMemories", "requeue" : false, "start": "start"},
        "start":
        {
            "id": "start",
            "type": Constants.LineType.Text,
            "text":
            "This place used to be packed, you know?",
            "nextId": "SushiCustomerMemories2"
        },
        "SushiCustomerMemories2" :
        {
            "id" : "SushiCustomerMemories2",
            "type": Constants.LineType.Text,
            "text":
            "They had a Japanese chef who was world famous for his spaghetti. Everyone came here to see how he cooked it!",
            "nextId" : "SushiCustomerMemories3"
        },
        "SushiCustomerMemories3" :{
            "id" : "SushiCustomerMemories3",
            "type": Constants.LineType.Text,
            "text":
            "You know you were the only one who's spoken to me all night? I'd like you to have this picture of the old chef, as thanks for entertaining this old man.",
            "rewards" : [ "japanese_bird_portrait"]
        }
        }
    )
