extends Node2D

var rng = RandomNumberGenerator.new()

const Giko = preload("res://Giko/Giko.gd")
const PlayerGiko = preload("res://Giko/PlayerGiko.gd")

var gikoPrefab = preload("res://Giko/Giko.tscn")
var playerGikoPrefab = preload("res://Giko/PlayerGiko.tscn")

var messages: Dictionary = {}

var totalMessages = 0
var totalGikos = 0

var playerGiko : PlayerGiko

var activeItems : Dictionary = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#loadRandomRoom()
	loadRoom("bar")
	for _i in range(1):  #for _i in range(Utils.rng.randi() % 15):
		spawnRandomGiko()
	spawnPlayerGiko(Rooms.currentRoomData["doors"].keys()[0])


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
	print("target:")
	print(target)
	print("Going to : " + target["roomId"] + " (door : " + target["doorId"] + ")")
	loadRoom(target["roomId"])
	$"%zObjects".add_child(playerGiko)
	for _i in range(Utils.rng.randi() % 15):
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



func spawnRandomGiko() -> void:
	spawnGiko(Constants.Character.values()[Utils.rng.randi() % Constants.Character.values().size()])


func loadRoom(roomName: String) -> void:
	Rooms.updateRoomData(roomName)
	var newRoomTexture = load("res://" + Rooms.ROOMS[roomName]["backgroundImageUrl"])
	$Background.scale = Vector2(Rooms.currentRoomScale, Rooms.currentRoomScale)
	$Background.texture = newRoomTexture
	$Background.position = Rooms.getCurrentRoomOffset()
	
	loadObjects()
	loadItems()
	return


func loadObjects() -> void:
	for object in Rooms.currentRoomData["objects"]:
		var objectSprite = Sprite.new()
		objectSprite.centered = false
		objectSprite.texture = load(
			"res://rooms/" + Rooms.currentRoomData["id"] + "/" + object["url"]
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
	if Items.ACTIVE_ITEMS.has(Rooms.currentRoomData["id"]):
		for item in Items.ACTIVE_ITEMS[Rooms.currentRoomData["id"]]:
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

func removeActiveItem(item : Dictionary) -> void:
	print(activeItems)
	var tile = Vector2(item["x"], item["y"])
	if activeItems.has(tile):
		activeItems[tile].queue_free()
		activeItems.erase(tile)


func spawnPlayerGiko(door: String) -> void:
	var newGiko = playerGikoPrefab.instance()
	newGiko.setCharacter(Constants.Character.Giko)
	newGiko.setName("feor")

	## prepare callbacks
	newGiko.changeRoom = funcref(self, "changeRoom")
	newGiko.removeActiveItem = funcref(self, "removeActiveItem")
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
	playerGiko.message("Everyone I don't know is Tokiko.")


func spawnGiko(character: int) -> void:
	totalGikos += 1
	var newGiko = gikoPrefab.instance()
	newGiko.setCharacter(character)
	newGiko.setName(Constants.GIKO_NAMES[rng.randi() % Constants.GIKO_NAMES.size()])

	newGiko.connect("messaged", self, "_on_giko_messaged")
	newGiko.connect("died", self, "_on_giko_died")
	$"%zObjects".add_child(newGiko)

func _on_spawn_pressed():
	#spawnGiko(Constants.Character.Giko)
	spawnRandomGiko()


func _on_giko_messaged():
	totalMessages += 1


func _on_giko_died():
	totalGikos -= 1


func _on_giko_spawned():
	totalGikos += 1
