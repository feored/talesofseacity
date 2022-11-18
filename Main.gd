extends Node2D

var rng = RandomNumberGenerator.new()

const Giko = preload("res://Giko/Giko.gd")
const PlayerGiko = preload("res://Giko/PlayerGiko.gd")

var gikoPrefab = preload("res://Giko/Giko.tscn")
var playerGikoPrefab = preload("res://Giko/PlayerGiko.tscn")
var gikoCoinPrefab = preload("res://FX/GikoCoin.tscn")

var messages: Dictionary = {}

var totalMessages = 0
var totalGikos = 0

var playerGiko : PlayerGiko

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	loadRandomRoom()
	#loadRoom("densha")
	for _i in range(1):  #for _i in range(Utils.rng.randi() % 15):
		spawnRandomGiko()
	spawnPlayerGiko(Rooms.currentRoomData["doors"].keys()[0])


func loadRandomRoom() -> void:
	#loadRoom("admin")
	loadRoom(Rooms.ROOMS.keys()[Utils.rng.randi() % Rooms.ROOMS.keys().size()])


func cleanRoom() -> void:
	for n in $"%Gikos".get_children():
		$"%Gikos".remove_child(n)
		n.queue_free()


func changeRoom(target):
	cleanRoom()
	print("Going to : " + target["roomId"] + " (door : " + target["doorId"] + ")")
	loadRoom(target["roomId"])
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


func spawnCoin(pos) -> void:
	var newCoin = gikoCoinPrefab.instance()
	newCoin.position = pos
	$FX.add_child(newCoin)


func spawnRandomGiko() -> void:
	for _i in range(State.gikosSpawnedOnClick):
		spawnGiko(Constants.Character.values()[randi() % Constants.Character.values().size()])


func loadRoom(roomName: String) -> void:
	Rooms.updateRoomData(roomName)
	var newRoomTexture = load("res://" + Rooms.ROOMS[roomName]["backgroundImageUrl"])
	$Background.scale = Vector2(Rooms.currentRoomScale, Rooms.currentRoomScale)
	$Background.texture = newRoomTexture
	$Background.position = Rooms.getCurrentRoomOffset()
	
	loadObjects()
	return


func loadObjects() -> void:
	for object in Rooms.currentRoomData["objects"]:
		var objectSprite = Sprite.new()
		objectSprite.centered = false
		objectSprite.texture = load(
			"res://rooms/" + Rooms.currentRoomData["id"] + "/" + object["url"]
		)
		$"%Gikos".add_child(objectSprite)
		var roomOffset: Vector2 = Rooms.getCurrentRoomOffset()
		objectSprite.position = Vector2(
			roomOffset.x + object["offset"]["x"], roomOffset.y + object["offset"]["y"]
		)


func spawnPlayerGiko(door: String) -> void:
	var newGiko = playerGikoPrefab.instance()
	newGiko.setCharacter(Constants.Character.Giko_Hat)
	newGiko.setName("Gunth")

	## prepare callbacks
	newGiko.changeRoom = funcref(self, "changeRoom")
	newGiko.place(
		Vector2(
			Rooms.currentRoomData["doors"][door]["x"],
			Rooms.currentRoomData["doors"][door]["y"]
		),
		Utils.roomDirectionToEnum(Rooms.currentRoomData["doors"][door]["direction"])
	)

	$"%Gikos".add_child(newGiko)
	playerGiko = newGiko


func spawnGiko(character: int) -> void:
	if State.serverSize <= totalGikos:
		return
	totalGikos += 1
	var newGiko = gikoPrefab.instance()
	newGiko.setCharacter(character)
	newGiko.setName(Constants.GIKO_NAMES[rng.randi() % Constants.GIKO_NAMES.size()])

	newGiko.connect("messaged", self, "_on_giko_messaged")
	newGiko.connect("died", self, "_on_giko_died")
	$"%Gikos".add_child(newGiko)
	$UI/StatBar.updateGikos(totalGikos)
	State.addActivity(1)


func _on_spawn_pressed():
	#spawnGiko(Constants.Character.Giko)
	spawnRandomGiko()


func _on_giko_messaged():
	totalMessages += 1
	State.addActivity(1)


func _on_giko_died():
	totalGikos -= 1
	$UI/StatBar.updateGikos(totalGikos)


func _on_giko_spawned():
	totalGikos += 1
	$UI/StatBar.updateGikos(totalGikos)
