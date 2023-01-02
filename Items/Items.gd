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
	],
	"yoshinoya": [
		{
			"x": 10,
			"y": 11,
			"id":"gikoburger",
			"world_scale":0.02,
			"rotation":0
		}
	],
	"yatai" : [
		{
			"x": 0,
			"y": 5,
			"id": "chef_knife",
			"world_scale": 0.05,
			"rotation": 0
		}
	]
}

var ITEMS = {
	"mahjong_red_dragon" : {
		"url" : "res://Items/images/mahjong_red_dragon.png",
		"id" : "mahjong_red_dragon",
		"name" : "Mahjong Tile (Red Dragon)",
		"description" : "A tile used in the game of Mahjong...",
		"default_world_scale" : 0.1,
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
		"default_world_scale": 0.02
	},
	"japanese_bird_portrait" : {
		"url" : "res://Items/Images/japanesebird.jpg",
		"id" : "japanese_bird_portrait",
		"name" : "Japanese Chef Portrait",
		"description" :"""This is a portrait of a Japanese Chef who was apparently famous for his spaghetti.""",
		"default_world_scale": 1
	},
	"bunny_comic" : {
		"url" : "res://Items/Images/bunnyseries.jpg",
		"id" : "bunny_comic",
		"name" : "Bunnyseries comic",
		"description" :"""A comic book called Bunnyseries, following the lives of anthropomorphic bunnies.
		The description on the back says it's a 'slice of life 4koma' and that the target audience is depressed people with no friends.""",
		"default_world_scale": 0.03
	},
	"data_chip" : {
		"url" : "res://Items/Images/data_chip.png",
		"id" : "data_chip",
		"name" : "Data Chip",
		"description" :"""A data chip containing instructions from the Prof.
		It looks like a cross between a SD card and a cartridge.""",
		"default_world_scale": 0.03
	},
	"data_chip_2": {
		"url" : "res://Items/Images/data_chip.png",
		"id" : "data_chip_2",
		"name" : "Data Chip (New)",
		"description" :"""Another data chip containing instructions from the Prof.
		Hopefully this one fixes the mess caused by the first one.""",
		"default_world_scale": 0.03
	},
	"flashlight" : {
		"url" : "res://Items/Images/data_chip.png",
		"id" : "flashlight",
		"name" : "Flashlight",
		"description" :"""A flashlight to allow you to see in the dark.
		Useful during a blackout.""",
		"default_world_scale": 0.03
	},
	"wrench": {
		"url" : "res://Items/Images/data_chip.png",
		"id" : "wrench",
		"name" : "Wrench",
		"description" :"""A wrench used by Sea City Engineers.""",
		"default_world_scale": 0.03
	},
	"salmon_steak": {
		"url" : "res://Items/Images/salmon_steak.png",
		"id" : "salmon_steak",
		"name" : "Salmon Steak",
		"description" :"""A fresh Salmon steak. It looks a little bit gruesome, when you consider where it came from.""",
		"default_world_scale": 0.03
	},
	"chef_knife": {
		"url" : "res://Items/Images/chef_knife.png",
		"id" : "chef_knife",
		"name" : "Chef's Knife",
		"description" :"""A very sharp knife. Be careful not to cut yourself.""",
		"default_world_scale": 0.03
	},
	"fishing_pole": {
		"url" : "res://Items/Images/fishing_rod.png",
		"id" : "fishing_pole",
		"name" : "Fishing Pole",
		"description" :"""A standard fishing pole. It has seen a lot of use.""",
		"default_world_scale": 0.03
	},
	"fresh_ika": {
		"url" : "res://Items/Images/fresh_ika.png",
		"id" : "fresh_ika",
		"name" : "Fresh Squid",
		"description" :"""A little squid, freshly caught in Well B. A delicacy in Sea City, often eaten with christmas cake.""",
		"default_world_scale": 0.03
	}
}



var INVENTORY = [ 
]

var BACKGROUND_ENVIRONMENT = {
	"silo":
	{
		Vector2(6,9) : 
		{
			"url" :  "res://Items/Images/machine_empty.png",
			"world_scale" : 0.03,
			"rotation": 0,
			"block" : true,
			"offset": Vector2(0, 0)
		}
	},
	"idoA":
	{
		Vector2(2,3) : 
		{
			"url" :  "res://Items/Images/fishing_rod.png",
			"world_scale" : 0.15,
			"rotation": 0,
			"block" : false,
			"offset": Vector2(25, -59)
		}
	}
	
}


func removeEnvironmentItem(roomId: String, position : Vector2) -> void:
	if BACKGROUND_ENVIRONMENT.has(roomId):
		if BACKGROUND_ENVIRONMENT[roomId].has(position):
			BACKGROUND_ENVIRONMENT[roomId].erase(position)

func addEnvironmentItem(roomId: String, position : Vector2, itemData : Dictionary) -> void:
	if BACKGROUND_ENVIRONMENT.has(roomId):
		BACKGROUND_ENVIRONMENT[roomId][position] = itemData
	else:
		BACKGROUND_ENVIRONMENT[roomId] = {position : itemData}
	

var ACTIVE_ENVIRONMENT = {
	"bar_st" :
	{
		Vector2(3, 3) : Utils.makeSimpleEnvironmentDialogue(["A vending machine. It sells Coco Cola and other refreshing beverages. It appears to be out of Dr. Pepper, however."])
	},
	"busstop" :
	{
		Vector2(1,1) : Utils.makeSimpleEnvironmentDialogue(["This sign shows the time table for the next bus. It seems that no bus is coming, because this is a train station and not a bus stop."])
	},
	"school_international":
	{
		Vector2(1,3) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(3,3) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(5,3) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(7,3) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(1,6) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(3,6) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(5,6) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(7,6) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. A student appears to have forgotten a comic book in the drawer."], true, "bunny_comic"),
		Vector2(1,9) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(3,9) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(5,9) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."]),
		Vector2(7,9) : Utils.makeSimpleEnvironmentDialogue(["A typical classroom desk, slightly worn out after being used by generations of school-aged gikos. There's nothing in the drawer."])
	},
	"gym":
	{
		Vector2(9,17): Utils.makeSimpleEnvironmentDialogue(["A picture of the most muscular Giko of all time, the mighty Buffolini, drawn by a local grade schooler."])
	},
	"school_ground":
	{
		Vector2(1,2): Utils.makeSimpleEnvironmentDialogue(["A jungle gym used by the local kids. The openings are too small for you to get inside."])
	},
	"jinja":
	{
		Vector2(5,2): Utils.makeSimpleEnvironmentDialogue(["A statue of Zonu."]),
		Vector2(5,6): Utils.makeSimpleEnvironmentDialogue(["A statue of Zonu."])
	},
	"takadai":
	{
		Vector2(0,10): Utils.makeSimpleEnvironmentDialogue(["These coin-operated binoculars would probably offer a pristine view of Sea City's beach if you had any money."]),
		Vector2(0,12): Utils.makeSimpleEnvironmentDialogue(["These coin-operated binoculars would probably offer a pristine view of Sea City's beach if you had any money."])
	},
	"silo":
	{
		Vector2(6,9): Utils.makeSimpleEnvironmentDialogue(["This weird machine doesn't seem to be plugged in to anything, but it's warm to the touch..."])
	}
}

func addEnvironmentDialogue(roomId: String, position: Vector2, dialogue: Dictionary) -> void:
	if (ACTIVE_ENVIRONMENT.has(roomId)):
		ACTIVE_ENVIRONMENT[roomId][position] = dialogue
	else:
		ACTIVE_ENVIRONMENT[roomId] = {position : dialogue}

func removeEnvironmentDialogue(roomId: String, position: Vector2) -> void:
	ACTIVE_ENVIRONMENT[roomId].erase(position)

func addEnvironmentDialogueRange(roomId: String, startPosition: Vector2, endPosition: Vector2, dialogue: Dictionary) -> void:
	if (!ACTIVE_ENVIRONMENT.has(roomId)):
		ACTIVE_ENVIRONMENT[roomId] = {}
	for _i in range(endPosition.x + 1 - startPosition.x):
		for _j in range(endPosition.y + 1 - startPosition.y):
			ACTIVE_ENVIRONMENT[roomId][Vector2(startPosition.x + _i, startPosition.y + _j)] = dialogue


func removeEnvironmentDialogueRange(roomId: String, startPosition: Vector2, endPosition: Vector2) -> void:
	for _i in range(endPosition.x + 1 - startPosition.x):
		for _j in range(endPosition.y + 1 - startPosition.y):
			ACTIVE_ENVIRONMENT[roomId].erase(Vector2(startPosition.x + _i, startPosition.y + _j))
			

func removeActiveItemAtPosition(roomId : String, itemId: String, position: Vector2) -> void:
	for item in ACTIVE_ITEMS[roomId]:
		if (item["id"] == itemId && Vector2(item["x"], item["y"]) == position):
			ACTIVE_ITEMS[roomId].erase(item)
	
func addActiveItem(roomId: String, itemId: String, position: Vector2, scale: float, rotation : float = 0) -> void:
	var newActiveItem = {
		"id": itemId,
		"x" : position.x,
		"y" : position.y,
		"world_scale" : scale,
		"rotation" : rotation
	}
	if ACTIVE_ITEMS.has(roomId):
		ACTIVE_ITEMS[roomId].push_back(newActiveItem)
	else:
		ACTIVE_ITEMS[roomId] = [newActiveItem]
	if Rooms.currentRoomId == roomId:
		get_node("/root/Main").loadItem(newActiveItem)

func addItemInventory(itemId : String) -> void:
	if itemId == "flashlight":
		QuestUtils.flashlight()
	inventoryRefreshNeeded = true
	INVENTORY.push_back(itemId)
	get_node(Constants.NOTIFICATIONS_PATH).addItemNotification(itemId, true)

func removeItemInventory(itemId : String) -> void:
	inventoryRefreshNeeded = true
	INVENTORY.erase(itemId)
	get_node(Constants.NOTIFICATIONS_PATH).addItemNotification(itemId, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func save() -> Dictionary:
	return {
		"ACTIVE_ENVIRONMENT" : ACTIVE_ENVIRONMENT,
		"INVENTORY" : INVENTORY,
		"BACKGROUND_ENVIRONMENT" : BACKGROUND_ENVIRONMENT,
		"ACTIVE_ITEMS" : ACTIVE_ITEMS
	}

func load(save : Dictionary) -> void:
	ACTIVE_ENVIRONMENT = save["ACTIVE_ENVIRONMENT"]
	INVENTORY = save["INVENTORY"]
	BACKGROUND_ENVIRONMENT = save["BACKGROUND_ENVIRONMENT"]
	ACTIVE_ITEMS = save["ACTIVE_ITEMS"]
	inventoryRefreshNeeded = true
