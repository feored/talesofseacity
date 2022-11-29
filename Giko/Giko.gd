extends AnimatedSprite
class_name Giko

signal messaged
signal died

const messagePrefab = preload("res://Giko/Message.tscn")

const MIN_NEXT_MOVE = 5
const MAX_NEXT_MOVE = 10

var character: int

var timeToNextDecision = 0
var timeSinceDecision = 0

var currentTile = Vector2(0, 0)
var currentTilePos: Vector2
var nextTile = Vector2(0, 0)
var nextTilePosition = Vector2(0, 0)
var currentDirection = Constants.Directions.DIR_LEFT

var isGhost = true if Utils.rng.randf() > 0.8 else false
var isMoving = false
var isSitting = false

var timeElapsed = 0
var timeSinceAction = Constants.TIME_TO_GHOST if isGhost else Utils.rng.randf() * Constants.TIME_TO_GHOST/2

var currentAction = Constants.Decisions.values() [randi() % Constants.Decisions.size()]

var currentMessage: Node


# Called when the node enters the scene tree for the first time.
func _ready():

	var isAlreadySeated = true if Utils.rng.randf() > 0.4 else false

	if (isAlreadySeated && Rooms.currentRoomData.has("sit") && Rooms.currentRoomData["sit"].size() > 0):
		var randomSeat = Rooms.currentRoomData["sit"][Utils.rng.randi() % Rooms.currentRoomData["sit"].size()]
		currentTile = Vector2(randomSeat["x"], randomSeat["y"])
	else:
		currentTile = Rooms.currentRoomWalkableTiles[Utils.rng.randi() % Rooms.currentRoomWalkableTiles.size()]

	Rooms.updateGikoPosition(self, currentTile)

	currentTilePos = Utils.getTilePosAtCoords(currentTile)
	position = Utils.getTilePosAtCoords(currentTile)
	currentDirection = getRandomDirection()
	
	checkSitting()
	play(getRightAnimation())
	setRightFlip()



func findEmptySeat(nearest = false) -> Vector2:
	if (!Rooms.currentRoomData.has("sit") or Rooms.currentRoomData["sit"].size() < 1):
		return currentTile

	var emptySeats = []
	for seat in Rooms.currentRoomData["sit"]:
		var currentSeat = Vector2(seat["x"], seat["y"])
		if (Rooms.getTilePopulation(currentSeat) == 0):
			emptySeats.push_back(currentSeat)
	
	if emptySeats.size() == 0:
		return currentTile
	
	if nearest:
		var closestEmptySeat = emptySeats[0]
		var closestDiff = Utils.getTileDistance(currentTile, closestEmptySeat)
		for currentSeat in emptySeats:
			if (Rooms.getTilePopulation(currentSeat) == 0):
				var diff = Utils.getTileDistance(currentTile, currentSeat)
				if diff < closestDiff:
					closestEmptySeat = currentSeat
					closestDiff = diff
		return closestEmptySeat
	else:
		return emptySeats[Utils.rng.randi() % emptySeats.size()]

func findPathToTile(destination : Vector2) -> Array:
	##A*
	var openTiles = {}

	var cameFrom = {}
	var costSoFar = {}

	cameFrom[currentTile] = null
	costSoFar[currentTile] = 0

	openTiles[currentTile] = 0

	while openTiles.size() > 0:
		var examiningTile = openTiles.keys()[0]
		for tileData in openTiles.keys():
			if openTiles[tileData] < openTiles[examiningTile]:
				examiningTile = tileData

		openTiles.erase(examiningTile)

		if examiningTile == destination:
			break

		for nextTile in Utils.getValidNearbyTiles(examiningTile):
			var newCost = costSoFar[examiningTile] + 1
			if (!(costSoFar.has(nextTile)) or newCost < costSoFar[nextTile]):
				costSoFar[nextTile] = newCost
				var f = newCost + Utils.getTileDistance(nextTile, destination)
				openTiles[nextTile] = f
				cameFrom[nextTile] = examiningTile

	
	## reconstruct path

	if ( !(cameFrom.has(destination))):
		return []
	var path = []
	var current = destination
	while current != currentTile:
		path.push_back(current)
		current = cameFrom[current]
	path.invert()

	return path
		




func takeDecision() -> void:
	if !isMoving && timeSinceDecision > timeToNextDecision:
		destroyMessage()
		match currentAction:
			Constants.Decisions.IDLE:
				idle()
			Constants.Decisions.FINDSEAT:
				findSeat()
			Constants.Decisions.CHANGEDIRECTION:
				changeDirection()
			Constants.Decisions.TALK:
				talk()
			Constants.Decisions.MOVESOMEWHERE:
				moveRandom()
		## random chance to change action
		if Utils.rng.randf() > 0.75:
			currentAction = Constants.Decisions.values()[Utils.rng.randi() % Constants.Decisions.values().size()]
	return



func idle() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(5)
	return

func talk() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(5)
	try_message()

func moveRandom() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(0.75, 0.25)

	var randomWalkableTile = Rooms.currentRoomWalkableTiles[Utils.rng.randi() % Rooms.currentRoomWalkableTiles.size()]
	var pathToSeat = findPathToTile(randomWalkableTile)

	if (pathToSeat.size() < 1):
		return

	var firstTile = pathToSeat[0]
	var firstTileDirection = Vector2(firstTile.x - currentTile.x, firstTile.y - currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	move(directionToTake)
	return


func changeDirection() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(5)

	var possibleDirections = Constants.Directions.values()
	possibleDirections.erase(currentDirection)
	currentDirection = possibleDirections[Utils.rng.randi() % possibleDirections.size()]
	
	checkSitting()
	play(getRightAnimation())
	setRightFlip()
	return

func findSeat() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(0.75, 0.25)

	var randomSeat = findEmptySeat()
	var pathToSeat = findPathToTile(randomSeat)

	if (pathToSeat.size() < 1):
		return

	var firstTile = pathToSeat[0]
	var firstTileDirection = Vector2(firstTile.x - currentTile.x, firstTile.y - currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	move(directionToTake)
	return



func setCharacter(newChar: int) -> void:
	character = newChar
	setCharacterTexture(newChar)


func setName(gikoName: String) -> void:
	$Control/ColorRect/Name.text = gikoName
	$Control/ColorRect/Name.rect_size = $Control/ColorRect/Name.get_font("font").get_string_size($Control/ColorRect/Name.text)
	$Control/ColorRect.rect_size = $Control/ColorRect/Name.rect_size + Vector2(10,0)
	#$Control/ColorRect.set_anchors_and_margins_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_KEEP_SIZE)
	$Control/ColorRect.rect_position = (Vector2((-$Control/ColorRect.rect_size.x/2), 0))
	$Control/ColorRect/Name.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)


func _process(delta):
	## Defines draw order
	#$tile.	text = String(currentTile)
	timeElapsed += delta
	timeSinceAction += delta
	timeSinceDecision += delta

	takeDecision()

	z_index = position.y

	process_movement(delta)
	checkGhost()


func try_message() -> void:
	message(Constants.POSSIBLE_MESSAGES[Utils.rng.randi() % Constants.POSSIBLE_MESSAGES.size()])


func process_movement(delta) -> void:
	if isMoving:
		if Utils.isPositionTooFar(position, nextTilePosition, currentDirection):
			# we have arrived at the tile
			position = nextTilePosition
			currentTile = nextTile
			currentTilePos = Utils.getTilePosAtCoords(currentTile)
			isMoving = false
			checkSitting()
			play(getRightAnimation())
			checkDoors()
		else:
			#play(getRightAnimation())
			position += Utils.getDirectionPixels(currentDirection) * delta * Constants.GIKO_MOVESPEED



func checkGhost() -> void:
	if timeSinceAction > Constants.TIME_TO_GHOST && !isGhost:
		isGhost = true
		self_modulate = Constants.GHOST_COLOR
	elif isGhost && timeSinceAction < Constants.TIME_TO_GHOST:
		isGhost = false
		self_modulate = Constants.NORMAL_COLOR

func checkSitting() -> void:
	var willSit = false
	if Rooms.currentRoomData.has("sit"):
		for sitTile in Rooms.currentRoomData["sit"]:
			if sitTile["x"] == currentTile.x && sitTile["y"] == currentTile.y:
				willSit = true
				break
	isSitting = willSit

func checkDoors() -> void:
	if Rooms.currentRoomData.has("doors"):
		for door in Rooms.currentRoomData["doors"].keys():
			var currentDoor = Rooms.currentRoomData["doors"][door]
			if currentDoor["target"] != null && currentDoor["x"] == currentTile.x && currentDoor["y"] == currentTile.y:
				## we are on a door
				queue_free()


func getRandomDirection() -> int:
	return Constants.Directions.values()[Utils.rng.randi() % Constants.Directions.size()]


func getRightAnimation() -> String:
	if isMoving:
		if (
			currentDirection == Constants.Directions.DIR_LEFT
			or currentDirection == Constants.Directions.DIR_UP
		):
			return Constants.GIKOANIM_BACK_WALKING
		else:
			return Constants.GIKOANIM_FRONT_WALKING
	else:
		if (
			currentDirection == Constants.Directions.DIR_LEFT
			or currentDirection == Constants.Directions.DIR_UP
		):
			return (
				Constants.GIKOANIM_BACK_SITTING
				if isSitting
				else Constants.GIKOANIM_BACK_STANDING
			)
		else:
			return (
				Constants.GIKOANIM_FRONT_SITTING
				if isSitting
				else Constants.GIKOANIM_FRONT_STANDING
			)


func setRightFlip() -> void:
	if (
		currentDirection == Constants.Directions.DIR_LEFT
		or currentDirection == Constants.Directions.DIR_DOWN
	):
		flip_h = true
	else:
		flip_h = false

func message(text) -> void:
	emit_signal("messaged")
	spawnMessage(text)


func spawnMessage(text) -> void:
	timeSinceAction = 0
	currentMessage = messagePrefab.instance()
	currentMessage.setMessage(text)
	$MessageRoot.add_child(currentMessage)


func destroyMessage() -> void:
	timeSinceAction = 0
	if currentMessage != null:
		currentMessage.delete()
		currentMessage = null


func move(toDirection: int) -> void:
	if Utils.canMoveInDirection(currentTile, toDirection):
		timeSinceAction = 0
		nextTile = Utils.getTileCoordsInDirection(currentTile, toDirection)

		currentDirection = toDirection
		nextTilePosition = Utils.getTilePosAtCoords(nextTile)

		isMoving = true
		play(getRightAnimation())
		setRightFlip()
		Rooms.updateGikoPosition(self, nextTile, currentTile)



func setCharacterTexture(newCharacter) -> void:
	var newCharacterPath = "res://Characters/" + Constants.CHARACTERS[newCharacter] + "/"

	var backStanding = load(newCharacterPath + Constants.GIKOANIM_BACK_STANDING + ".png")
	var frontStanding = load(newCharacterPath + Constants.GIKOANIM_FRONT_STANDING + ".png")

	var backSitting = load(newCharacterPath + Constants.GIKOANIM_BACK_SITTING + ".png")
	var frontSitting = load(newCharacterPath + Constants.GIKOANIM_FRONT_SITTING + ".png")

	var backWalking1 = load(newCharacterPath + Constants.GIKOANIM_BACK_WALKING + "-1" + ".png")
	var backWalking2 = load(newCharacterPath + Constants.GIKOANIM_BACK_WALKING + "-2" + ".png")

	var frontWalking1 = load(newCharacterPath + Constants.GIKOANIM_FRONT_WALKING + "-1" + ".png")
	var frontWalking2 = load(newCharacterPath + Constants.GIKOANIM_FRONT_WALKING + "-2" + ".png")

	# if frames != null:
	# 	frames.free()
	frames = SpriteFrames.new()
	for anim in [
		Constants.GIKOANIM_BACK_STANDING,
		Constants.GIKOANIM_FRONT_STANDING,
		Constants.GIKOANIM_BACK_WALKING,
		Constants.GIKOANIM_FRONT_WALKING,
		Constants.GIKOANIM_BACK_SITTING,
		Constants.GIKOANIM_FRONT_SITTING
	]:
		frames.add_animation(anim)
		frames.set_animation_speed(anim, 16)
		frames.set_animation_loop(anim, true)

	frames.add_frame(Constants.GIKOANIM_BACK_STANDING, backStanding)
	frames.add_frame(Constants.GIKOANIM_FRONT_STANDING, frontStanding)

	frames.add_frame(Constants.GIKOANIM_BACK_SITTING, backSitting)
	frames.add_frame(Constants.GIKOANIM_FRONT_SITTING, frontSitting)

	frames.add_frame(Constants.GIKOANIM_BACK_WALKING, backWalking1)
	frames.add_frame(Constants.GIKOANIM_BACK_WALKING, backWalking2)

	frames.add_frame(Constants.GIKOANIM_FRONT_WALKING, frontWalking1)
	frames.add_frame(Constants.GIKOANIM_FRONT_WALKING, frontWalking2)
