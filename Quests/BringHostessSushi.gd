extends Quest

var quest_stages = {
    "initial":
    {
        "id": "initial",
        "condition": "talkedToSushiSalaryman",
        "entry" : "I've talked to the tired salaryman at the sushi vendor who's looking for some entertainment. Maybe I could find someone to liven up the place.",
        "next" : "talkToHostess"
    },
    "talkToHostess" :{
       "id" : "talkToHostess",
       "condition" : "talkedToHostess",
       "entry" : "I've talked to the bored hostess in bar street. She refuses to entertain the tired salaryman as long as the sushi vendor's atmosphere and food does not improve.",
       "completed" :"addSushiChefDialogue",
       "next" : "talkToChef"
    },
    "talkToChef" :{
        "id": "talkToOldCustomer",
        "condition" : "needSalmon",
        "entry" : "It would seem the only way to revitalize the sushi place is to bring the chef some fresh fish...But where can I find fresh fish in Sea City?",
        "completed": "addFisherDialogue",
        "next" : "bringBackSalmon"
    },
    "bringBackSalmon" : {
        "id" : "bringBackSalmon",
        "condition" : "broughtBackSalmon",
        "completed": "addCompletedDialogue",
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

func needSalmon() -> bool:
    return Quests.QUEST_FLAGS["qSushiNeedSalmon"]

func broughtBackSalmon() -> bool:
    return Items.INVENTORY.has("salmon_steak")


## COMPLETED

func addCompletedDialogue() -> void:
    pass

func addFisherDialogue() -> void:
    Items.addEnvironmentDialogueRange("idoA", Vector2(2,3), Vector2(4,5), 
        Utils.makeSimpleDialogue(["You can't fish here you fucking idiot"])
    )

    NPCs.addQuestDialogue(
        "idoA",
        "WellFisher",
        {
            "info": {"name": "Fisher", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text": "Hey there! Why don't you have a seat and fish with me?",
                "nextId": "fisher2"
            },
            "fisher2" :
            {
                "id" : "fisher2",
                "type": Constants.LineType.Choice,
                "choices" : [
                    {
                        "text": "I'm afraid I don't have a fishing pole...",
                        "condition": {
                            "type" : Constants.ConditionType.NoItem,
                            "value" : "fishing_pole"
                        },
                        "nextId": "fisher3"
                    },
                    {
                        "text": "Maybe later!"
                    }
                ]
            },
            "fisher3":
            {
                "id": "fisher3",
                "type": Constants.LineType.Text,
                "text": "That's unfortunate! I have a spare here I'd be willing to trade for a decent knife. I have caught so many fish, and yet I have nothing to filet them with...",
                "nextId": "fisher4"
            },
            "fisher4":
            {
                "id": "fisher4",
                "type": Constants.LineType.Choice,
                "choices": 
                [
                    {
                        "text": "How about this Chef's Knife? It was used by a sushi chef. [Give Knife]",
                        "costs": ["chef_knife"],
                        "nextId": "fisher5",
                        "condition": {
                            "type" : Constants.ConditionType.Item,
                            "value" : "chef_knife"
                        }
                    },
                    {
                        "text": "Sorry, I don't have a spare knife. Good luck with the fishing.",
                    }
                ]
            },
            "fisher5":
            {
                "id": "fisher5",
                "type": Constants.LineType.Text,
                "rewards": ["fishing_pole"],
                "text": "Perfect! Here, have this fishing pole. To start fishing, just stand in front of the well"
            }
        })



func addSushiChefDialogue() -> void:
    NPCs.addQuestDialogue(
        "yatai",
        "SushiChef",
        {
            "info": {"name": "SushiChefIntro", "requeue": true, "start": "start"},
            "start":
            {
                "id": "start",
                "type": Constants.LineType.Text,
                "text":
                "Can I help you sir?",
                "nextId": "SushiChef2"
            },
            "SushiChef2":
            {
                "id": "SushiChef2",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "Why are there so few customers here?",
                        "nextId": "SushiChef4"
                    },
                    {
                        "text": "I'm hungry. Hurry up!",
                        "nextId": "SushiChef3"
                    }
                ]
            },
            "SushiChef3":
            {
                "id": "SushiChef3",
                "type": Constants.LineType.Text,
                "text":
                "I'm doing my best! Please wait for your turn. The salmon we have left is really tough."
            },
            "SushiChef4":
            {
                "id": "SushiChef4",
                "type": Constants.LineType.Text,
                "text":
                "We've had difficulty sourcing fresh fish. Have you seen any fishermen in Sea City recently?",
                "nextId": "SushiChef5"
            },
            "SushiChef5":
            {
                "id": "SushiChef5",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "I see. Good luck with that.",
                    },
                    {
                        "text": "Is there any way I could help you to bring in some new customers?",
                        "nextId": "SushiChef6"
                    }
                ]
            },
            "SushiChef6":
            {
                "id": "SushiChef6",
                "type": Constants.LineType.Text,
                "text":
                "If you know where to get fresh fish in this town, that'd be a great help!",
                "flags": [{"flag": "qSushiNeedSalmon", "type": "set", "value": true}]
            },
        })


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
                        "nextId": "BoredHostess6",
                        "flags" : [{"flag": "qTalkedToHostess", "type": "set", "value": true}]
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
                "Hah! Only old geezers eat there! No way! Besides, I heard their food isn't very good.",
                "nextId" : "BoredHostess7"
            },
            "BoredHostess7" :
            {
                "id": "BoredHostess7",
                "type": Constants.LineType.Choice,
                "choices":
                [
                    {
                        "text": "Actually, I heard they just acquired a fresh shipment of salmon of the highest quality.",
                        "condition": {
                            "type" : Constants.ConditionType.Flag,
                            "value" : "qSushiNewSalmon"
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
                "Oh ho! In that case, why not whore ourselves? I'll be right there.",
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
            "You know you are the only one who's spoken to me all night? I'd like you to have this picture of the old chef, as thanks for entertaining this old man.",
            "rewards" : [ "japanese_bird_portrait"]
        }
        }
    )
