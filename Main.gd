extends Node2D

var rng = RandomNumberGenerator.new()

const Giko = preload("res://Giko/Giko.gd")
const PlayerGiko = preload("res://Giko/PlayerGiko.gd")

var gikoPrefab = preload("res://Giko/Giko.tscn")
var playerGikoPrefab = preload("res://Giko/PlayerGiko.tscn")

var messages: Dictionary = {}

var totalMessages = 0

var playerGiko : PlayerGiko

var activeItems : Dictionary = {}
var activeNPCs : Dictionary = {}

onready var dialogueManager = $"%Dialogue"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#loadRandomRoom()
	loadRoom("konbini")
	for _i in range(1):  #for _i in range(Utils.rng.randi() % 15):
		spawnRandomGiko()
	spawnPlayerGiko(Rooms.currentRoomData["doors"].keys()[0])
	# dialogueManager.setLineSet(Utils.makeSimpleDialogue([
	# 	"Welcome to Giko Story!",
	# 	"This server is an amalgamation of the international and Japanese servers.",
	# 	"Go explore, talk to everyone, pick up items and have fun!"
	# ]), "")
	# dialogueManager.setAuthor("")
	# dialogueManager.show()


func loadRandomRoom() -> void:
	#loadRoom("admin")
	loadRoom(Rooms.ROOMS.keys()[Utils.rng.randi() % Rooms.ROOMS.keys().size()])


func cleanRoom() -> void:
	for n in $"%zObjects".get_children():
		$"%zObjects".remove_child(n)
		n.queue_free()


func changeRoom(target):
	$"%zObjects".remove_child(playerGiko)
	cleanRoom()
	loadRoom(target["roomId"])
	$"%zObjects".add_child(playerGiko)
	for _i in range(Utils.rng.randi() % 10):
		spawnRandomGiko()
	playerGiko.place(
		Vector2(
			Rooms.currentRoomData["doors"][target["doorId"]]["x"],
			Rooms.currentRoomData["doors"][target["doorId"]]["y"]
		),
		Utils.roomDirectionToEnum(Rooms.currentRoomData["doors"][target["doorId"]]["direction"])
	)
	#spawnPlayerGiko(target["doorId"])



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func loadRoom(roomName: String) -> void:
	Rooms.updateRoomData(roomName)
	var newRoomTexture = load("res://" + Rooms.ROOMS[roomName]["backgroundImageUrl"])
	$Background.scale = Vector2(Rooms.currentRoomScale, Rooms.currentRoomScale)
	$Background.texture = newRoomTexture
	$Background.position = Rooms.getCurrentRoomOffset()
	
	loadObjects()
	loadItems()
	loadNPCs()
	return


func loadObjects() -> void:
	for object in Rooms.currentRoomData["objects"]:
		var objectSprite = Sprite.new()
		objectSprite.centered = false
		objectSprite.texture = load(
			"res://rooms/" + Rooms.currentRoomId + "/" + object["url"]
		)
		$"%zObjects".add_child(objectSprite)
		var roomOffset: Vector2 = Rooms.getCurrentRoomOffset()
		objectSprite.position = Vector2(
			roomOffset.x + object["offset"]["x"], roomOffset.y + object["offset"]["y"]
		)
		var coords = Vector2(object["x"], object["y"])
		objectSprite.z_index = Utils.getTilePosAtCoords(coords).y

func loadItems() -> void:
	activeItems.clear()
	if Items.ACTIVE_ITEMS.has(Rooms.currentRoomId):
		for item in Items.ACTIVE_ITEMS[Rooms.currentRoomId]:
			var itemSprite = Sprite.new()
			var itemData = Items.ITEMS[item["id"]]
			#itemSprite.centered = false
			itemSprite.texture = load(itemData["url"])
			itemSprite.scale = Vector2(itemData["scale"], itemData["scale"])
			$"%zObjects".add_child(itemSprite)
			#var roomOffset: Vector2 = Rooms.getCurrentRoomOffset()
			#objectSprite.position = Vector2(
			#	roomOffset.x + item["x"], roomOffset.y + object["offset"]["y"]
			#)
			var coords = Vector2(item["x"], item["y"])
			itemSprite.position = Utils.getTilePosAtCoords(coords)
			itemSprite.z_index = itemSprite.position.y
			activeItems[coords] = itemSprite

func loadNPCs() -> void:
	activeNPCs.clear()
	if NPCs.ACTIVE_NPCs.has(Rooms.currentRoomId):
		for npcData in NPCs.ACTIVE_NPCs[Rooms.currentRoomId].values():
			spawnNPCGiko(npcData)


func removeActiveItem(item : Dictionary) -> void:
	print(activeItems)
	var tile = Vector2(item["x"], item["y"])
	if activeItems.has(tile):
		activeItems[tile].queue_free()
		activeItems.erase(tile)

func talkToNPC(NPCId : String) -> void:
	if (dialogueManager.isDialoguing):
		dialogueManager.skipToNext()
		return
	else:
		if (NPCs.ACTIVE_NPCs[Rooms.currentRoomId][NPCId].has("lines") && NPCs.ACTIVE_NPCs[Rooms.currentRoomId][NPCId]["lines"].size() > 0):
			var qLine = NPCs.ACTIVE_NPCs[Rooms.currentRoomId][NPCId]["lines"].pop_front()
			dialogueManager.setLineSet(qLine, NPCId)
			dialogueManager.show()
			if qLine["info"]["requeue"]:
				NPCs.ACTIVE_NPCs[Rooms.currentRoomId][NPCId]["lines"].push_back(qLine)
		elif NPCs.NPCs[NPCId].lines.size() > 0:
			var dialogueLine = NPCs.NPCs[NPCId].lines.pop_front()
			NPCs.NPCs[NPCId].lines.push_back(dialogueLine)
			dialogueManager.setLineSet(dialogueLine, NPCId)
			dialogueManager.show()

func spawnPlayerGiko(door: String) -> void:
	var newGiko = playerGikoPrefab.instance()
	newGiko.setCharacter(Constants.Character.Furoshiki)
	newGiko.setName("dinghy")

	## prepare callbacks
	newGiko.changeRoom = funcref(self, "changeRoom")
	newGiko.removeActiveItem = funcref(self, "removeActiveItem")
	newGiko.talkToNPC = funcref(self, "talkToNPC")
	newGiko.place(
		Vector2(
			Rooms.currentRoomData["doors"][door]["x"],
			Rooms.currentRoomData["doors"][door]["y"]
		),
		Utils.roomDirectionToEnum(Rooms.currentRoomData["doors"][door]["direction"])
	)

	$"%zObjects".add_child(newGiko)
	playerGiko = newGiko
	$Camera2D.player = playerGiko
	#playerGiko.message("I miss Mona.")


func spawnNPCGiko(NPCData : Dictionary) -> void:
	var newGiko = gikoPrefab.instance()
	newGiko.initializeNPC(NPCData)
	$"%zObjects".add_child(newGiko)

func spawnRandomGiko() -> void:
	var newGiko = gikoPrefab.instance()
	newGiko.initializeRandom()
	$"%zObjects".add_child(newGiko)

func _on_spawn_pressed():
	#spawnGiko(Constants.Character.Giko)
	spawnRandomGiko()


func _on_giko_messaged():
	totalMessages += 1
