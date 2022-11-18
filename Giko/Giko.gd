extends AnimatedSprite
class_name Giko

signal messaged
signal died

const messagePrefab = preload("res://Giko/Message.tscn")

const MIN_NEXT_MOVE = 5
const MAX_NEXT_MOVE = 10

var character: int

var timeElapsed = 0

var currentTile = Vector2(5, 5)
var currentTilePos: Vector2
var nextTile = Vector2(0, 0)
var nextTilePosition = Vector2(0, 0)
var currentDirection = Constants.Directions.DIR_LEFT

var timeToNextAction: int
var isMoving = false
var isSitting = false

var currentMessage: Node

var timeToNextMood: int
var currentMood: int

var execMood: Object
var endMood: Object
var canTakeAction: Object
var currentMoodData = {}

const GHOST_COLOR = Color(1, 1, 1, 0.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	#timeToNextMovement = Utils.rng.randf_range(MIN_NEXT_MOVE, MAX_NEXT_MOVE)
	# currentTile = Vector2(
	# 	Utils.rng.randi_range(-Constants.BASE_ROOM_SIZE.x, Constants.BASE_ROOM_SIZE.x),
	# 	Utils.rng.randi_range(-Constants.BASE_ROOM_SIZE.y, Constants.BASE_ROOM_SIZE.y)
	# )
	# var spawnPointName = Rooms.currentRoomData["spawnPoint"]
	# var spawnPoint = Rooms.currentRoomData["doors"][spawnPointName]

	# ## get random walkable tile

	# var validTile = false

	# ## Naive approach to avoid getting tiles that are blocked on all sides, ie on walls
	# ## Require at least one other non blocked tile nearby
	# while !validTile:
	# 	validTile = true
	# 	currentTile = Vector2(
	# 		Utils.rng.randi_range(0, Rooms.currentRoomData["size"]["x"]-1),
	# 		-Utils.rng.randi_range(0, Rooms.currentRoomData["size"]["y"]-1)
	# 	)
	# 	if Rooms.currentRoomData.has("blocked"):
	# 		print("Room has blocked tiles")
	# 		for blockedTile in Rooms.currentRoomData["blocked"]:
	# 			if (
	# 				float(blockedTile["x"]) == currentTile.x
	# 				&& float(blockedTile["y"]) == -currentTile.y
	# 			):
	# 				print("Tile not walkable, retrying")
	# 				validTile = false
	# 				break
	currentTile = Rooms.currentRoomWalkableTiles[Utils.rng.randi() % Rooms.currentRoomWalkableTiles.size()]

	currentTilePos = Utils.getTilePosAtCoords(currentTile)
	position = Utils.getTilePosAtCoords(currentTile)
	currentDirection = getRandomDirection()

	play(getRightAnimation())
	setRightFlip()
	setMood(pickMood())
	#add_to_group(Constants.GROUP_GIKOS)


func setCharacter(newChar: int) -> void:
	character = newChar
	setCharacterTexture(newChar)


func setName(gikoName: String) -> void:
	$ColorRect/Name.text = gikoName


func setMood(nextMood: int) -> void:
	currentMood = nextMood
	currentMoodData.clear()
	#print("Init new mood")
	match currentMood:
		Constants.Mood.IDLE:
			initMoodIdle()
		Constants.Mood.EXPLORE:
			initMoodExplore()
		Constants.Mood.TALK:
			initMoodTalk()
	timeToNextMood = timeElapsed + Constants.GIKO_MOOD_LENGTH


func pickMood() -> int:
	return [Constants.Mood.EXPLORE, Constants.Mood.IDLE, Constants.Mood.TALK][randi() % 3]
	#return Constants.Mood.values()[Utils.rng.randi() % Constants.Mood.values().size()]


func _process(delta):
	## Defines draw order
	#$tile.	text = String(currentTile)
	timeElapsed += delta

	process_movement(delta)

	if canTakeAction.call_func():
		if timeElapsed > timeToNextMood:
			#print("Ending mood")
			endMood.call_func()
			setMood(pickMood())
		else:
			execMood.call_func()


func try_message() -> void:
	message(Constants.POSSIBLE_MESSAGES[Utils.rng.randi() % Constants.POSSIBLE_MESSAGES.size()])


func process_movement(delta) -> void:
	if isMoving:
		if Utils.isPositionTooFar(position, nextTilePosition, currentDirection):
			# we have arrived at the tile
			position = nextTilePosition
			currentTile = nextTile
			currentTilePos = Utils.getTilePosAtCoords(currentTile)
			var willSit = false
			if Rooms.currentRoomData.has("sit"):
				for sitTile in Rooms.currentRoomData["sit"]:
					if sitTile["x"] == currentTile.x && sitTile["y"] == -currentTile.y:
						willSit = true
			isSitting = willSit
			isMoving = false
			play(getRightAnimation())
		else:
			#play(getRightAnimation())
			position += Utils.getDirectionPixels(currentDirection) * delta * Constants.GIKO_MOVESPEED


func getRandomDirection() -> int:
	return Constants.Directions.values()[randi() % Constants.Directions.size()]


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
	currentMessage = messagePrefab.instance()
	currentMessage.setMessage(text)
	$MessageRoot.add_child(currentMessage)


func destroyMessage() -> void:
	if currentMessage != null:
		currentMessage.delete()
		currentMessage = null


func move(toDirection: int) -> void:
	if Utils.canMoveInDirection(currentTile, toDirection):
		nextTile = Utils.getTileCoordsInDirection(currentTile, toDirection)

		currentDirection = toDirection
		nextTilePosition = Utils.getTilePosAtCoords(nextTile)

		isMoving = true
		play(getRightAnimation())
		setRightFlip()

func isMoveFinished() -> bool:
	return not isMoving and currentMoodData["start"] != currentTile


func isTimeToMove() -> bool:
	return timeElapsed > timeToNextAction


func setActionTimer(nextTime: float) -> void:
	timeToNextAction = timeElapsed + nextTime


### Every mood has 3 funcs necessary:
### init, exec, and end
### init sets the necessary parameters
### and sets the funcrefs that will be called
### for exec and end
### you can pass pass() as funcref to do nothing
### since lambdas are not supported in godot3

## MOOD IDLE


func initMoodIdle() -> void:
	self_modulate = GHOST_COLOR
	setActionTimer(Constants.GIKO_MOOD_LENGTH)
	canTakeAction = funcref(self, "isTimeToMove")
	execMood = funcref(self, "pass")
	endMood = funcref(self, "endMoodIdle")


func endMoodIdle() -> void:
	self_modulate = Color(1, 1, 1, 1)


## MOOD EXPLORE


func initMoodExplore() -> void:
	currentMoodData["direction"] = getRandomDirection()
	currentMoodData["start"] = currentTile
	canTakeAction = funcref(self, "isMoveFinished")
	execMood = funcref(self, "execMoodExplore")
	endMood = funcref(self, "pass")
	move(currentMoodData["direction"])


func execMoodExplore() -> void:
	##yield(get_tree().create_timer(0.1), "timeout")

	if Utils.rng.randi() % 100 == 0:
		currentMoodData["direction"] = getRandomDirection()
		currentMoodData["start"] = currentTile
	move(currentMoodData["direction"])


## MOOD TALK


func initMoodTalk() -> void:
	setActionTimer(2)
	canTakeAction = funcref(self, "isTimeToMove")
	execMood = funcref(self, "execMoodTalk")
	endMood = funcref(self, "endMoodTalk")


func execMoodTalk() -> void:
	setActionTimer(Utils.rng.randf_range(5, 15))
	destroyMessage()
	if Utils.rng.randi() % 2 == 0:
		message(Constants.POSSIBLE_MESSAGES[Utils.rng.randi() % Constants.POSSIBLE_MESSAGES.size()])


func endMoodTalk() -> void:
	destroyMessage()


func pass() -> void:
	pass


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

	if frames != null:
		frames.free()
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
