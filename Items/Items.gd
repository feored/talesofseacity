extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var inventoryRefreshNeeded = false

var ACTIVE_ITEMS = {
	"admin" : [
		{
			"x" : 0,
			"y" : 1,
			"id" : "mahjong_red_dragon",
            "world_scale": 0.1,
            "rotation" : 30
		}
	],
	"bar" : [
		{
			"x" : 0,
			"y" : 3,
			"id" : "zachu_guitar",
            "world_scale": 0.25,
            "rotation" : 0
		}
	]
}

var ITEMS = {
	"flash" : {
		"url" : "res://Items/images/flash.png",
		"id" : "flash",
		"name" : "Flash",
		"description" : "...",
		"default_world_scale" : 1
	},
	"mahjong_red_dragon" : {
		"url" : "res://Items/images/mahjong_red_dragon.png",
		"id" : "mahjong_red_dragon",
		"name" : "Mahjong Tile (Red Dragon)",
		"description" : "A tile used in the game of Mahjong...",
		"default_world_scale" : 0.1
	},
	"zachu_guitar" : {
		"url" : "res://Items/images/zachu_guitar.png",
		"id" : "zachu_guitar",
		"name" : "Zzazzachu's Guitar",
		"description" : """He uses it to play Twice as Nice & Half the Price by Heron.
		It has some white marks on the handle which could be either cocaine or cum.
		It would probably best to give it back to him next time he's around.""",
		"default_world_scale" : 0.25
	},
	"sunscreen" : {
		"url" : "res://Items/images/gikoscreen.png",
		"id" : "sunscreen",
		"name" : "Sunscreen",
		"description" : """A tube of GIKOSCREEN™ sunscreen, the most reputable brand of sunscreen in Sea City.
		Use it to protect your pale Giko skin from the sun.
		Rated SPF 100.""",
		"default_world_scale" : 0.2
	},
	"gikoburger":{
		"url" : "res://Items/Images/gikoburger2.png",
		"id" : "gikoburger",
		"name" : "Giko Burger (Giko Sando)",
		"description" :"""The Giko Sando is a classic item on the Giko Burger Menu.
		No one knows what it's really made out of.""",
		"default_world_scale": 0.2
	},
    "japanese_bird_portrait" : {
        "url" : "res://Items/Images/japanesebird.jpg",
		"id" : "japanese_bird_portrait",
		"name" : "Japanese Chef Portrait",
		"description" :"""This is a portrait of a Japanese Chef who was apparently famous for his spaghetti.""",
		"default_world_scale": 1
    }
}

var INVENTORY = [
	"sunscreen",
	"gikoburger"
]

var ACTIVE_ENVIRONMENT = {
    "bar_st" :
    {
        Vector2(3, 3) : Utils.makeSimpleEnvironmentDialogue(["A vending machine. It sells Coco Cola and other refreshing beverages. It appears to be out of Dr. Pepper, however."])
    },
    "busstop" :
    {
        Vector2(1,1) : Utils.makeSimpleEnvironmentDialogue(["This sign shows the time table for the next bus. It seems that no bus is coming, because this is a train station and not a bus stop."])
    }
}

func removeActiveItemAtPosition(roomId : String, itemId: String, position: Vector2) -> void:
    for item in ACTIVE_ITEMS[roomId]:
        if (item["id"] == itemId && Vector2(item["x"], item["y"]) == position):
            ACTIVE_ITEMS[roomId].erase(item)
    
func addActiveItem(roomId: String, itemId: String, position: Vector2, scale: float, rotation : float = 0) -> void:
    ACTIVE_ITEMS[roomId].push_back(
        {
            "id": itemId,
            "x" : position.x,
            "y" : position.y,
            "world_scale" : scale,
            "rotation" : 0
        }
    )

func addItemInventory(itemId : String) -> void:
	inventoryRefreshNeeded = true
	INVENTORY.push_back(itemId)

func removeItemInventory(itemId : String) -> void:
	inventoryRefreshNeeded = true
	INVENTORY.erase(itemId)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
