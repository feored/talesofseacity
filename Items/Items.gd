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
			"y" : 0,
			"id" : "mahjongTile"
		},
		{
			"x" : 0,
			"y" : 1,
			"id" : "mahjong_red_dragon"
		}
	],
	"bar" : [
		{
			"x" : 0,
			"y" : 3,
			"id" : "zachu_guitar"
		}
	]
}

var ITEMS = {
	"flash" : {
		"url" : "res://Items/images/flash.png",
		"id" : "flash",
		"name" : "Flash",
		"description" : "...",
		"scale" : 1
	},
	"mahjongTile" : {
		"url" : "res://Items/images/tile.png",
		"id" : "mahjongTile",
		"name" : "Mahjong Tile",
		"description" : "A tile used in the game of Mahjong...",
		"scale" : 0.5
	},
	"mahjong_red_dragon" : {
		"url" : "res://Items/images/mahjong_red_dragon.png",
		"id" : "mahjong_red_dragon",
		"name" : "Mahjong Tile (Red Dragon)",
		"description" : "A tile used in the game of Mahjong...",
		"scale" : 0.1
	},
	"zachu_guitar" : {
		"url" : "res://Items/images/zachu_guitar.png",
		"id" : "zachu_guitar",
		"name" : "Zzazzachu's Guitar",
		"description" : """He uses it to play Twice as Nice & Half the Price by Heron.
		It has some white marks on the handle which could be either cocaine or cum.
		It would probably best to give it back to him next time he's around.""",
		"scale" : 0.25
	}
}

var INVENTORY = [
	
]

func removeActiveItem(roomId : String, itemData : Dictionary) -> void:
	if ACTIVE_ITEMS.has(roomId):
		ACTIVE_ITEMS[roomId].erase(itemData)

func addItemInventory(itemId : String) -> void:
	inventoryRefreshNeeded = true
	INVENTORY.push_back(itemId)

func removeItemInventory(itemId : String) -> void:
	inventoryRefreshNeeded = true
	INVENTORY.erase(itemId)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
