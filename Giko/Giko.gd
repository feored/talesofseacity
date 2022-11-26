extends AnimatedSprite
class_name Giko

signal messaged
signal died

const messagePrefab = preload("res://Giko/Message.tscn")

const MIN_NEXT_MOVE = 5
const MAX_NEXT_MOVE = 10

var currentPersonality : int = Constants.PERSONALITIES.values()[Utils.rng.randi() % Constants.PERSONALITIES.values().size()]

var character: int



var timeToNextAction = 0

var timeToNextDecision = 0
var timeSinceDecision = 0

var currentTile = Vector2(5, 5)
var currentTilePos: Vector2
var nextTile = Vector2(0, 0)
var nextTilePosition = Vector2(0, 0)
var currentDirection = Constants.Directions.DIR_LEFT

var isGhost = true if Utils.rng.randf() > 0.8 else false
var isMoving = false
var isSitting = false

var timeElapsed = 0
var timeSinceAction = Constants.TIME_TO_GHOST if isGhost else Utils.rng.randf() * Constants.TIME_TO_GHOST/2

var currentMessage: Node



var speed = Utils.rng.randfn(Constants.GIKO_MIN_SPEED/2,  Constants.GIKO_MIN_SPEED/5)
var talkativeness = Utils.rng.randfn(50,  25)
var wanderlust = Utils.rng.randfn(50, 25)
#var 


# Called when the node enters the scene tree for the first time.
func _ready():
	currentTile = Rooms.currentRoomWalkableTiles[Utils.rng.randi() % Rooms.currentRoomWalkableTiles.size()]

	currentTilePos = Utils.getTilePosAtCoords(currentTile)
	position = Utils.getTilePosAtCoords(currentTile)
	currentDirection = getRandomDirection()
	
	checkSitting()
	play(getRightAnimation())
	setRightFlip()
	print("Speed : %s, Talkativeness : %s, Wanderlust : %s" % [speed, talkativeness, wanderlust])


func takeDecision() -> void:
	if !isMoving && timeSinceDecision > timeToNextDecision:
		# pick between moving, talking, and doing nothing
		var nextAction = Utils.rng.randi() % (int(talkativeness+wanderlust)*5)
		print("next action result = %s" % nextAction)
		if nextAction < wanderlust:
				var validNearbyDirections = Utils.getValidNearbyDirections(currentTile)
				var nextDirection = validNearbyDirections[Utils.rng.randi() % validNearbyDirections.size()]
				move(nextDirection)
		elif nextAction < wanderlust + talkativeness:
				destroyMessage()
				if (Utils.rng.randf() > 0.5):
					try_message()
		else:
			timeSinceDecision = 0
		timeToNextDecision = Utils.rng.randfn(Constants.GIKO_MIN_SPEED - speed)
		print("Time to next Decision %s" %  timeToNextDecision)






# ### personalities

# func takeDecision() -> void:
# 	match currentPersonality:
# 		Constants.PERSONALITIES.Explorer:
# 			explorer()
# 		Constants.PERSONALITIES.Afk:
# 			afk()
# 		_:
# 			afk()

# func afk() -> void:
# 	pass # lol

# func explorer() -> void:
# 	if !isMoving && timeSinceAction > timeToNextAction:
# 		var nextDecision = Utils.rng.randi() % 100
# 		if nextDecision > 60:
# 			var validNearbyDirections = Utils.getValidNearbyDirections(currentTile)
# 			var nextDirection = validNearbyDirections[Utils.rng.randi() % validNearbyDirections.size()]
# 			move(nextDirection)
# 		elif nextDecision > 55:
# 			if Utils.rng.randf() < 0.5:
# 				destroyMessage()
# 			else:
# 				destroyMessage()
# 				try_message()
# 		else:
# 			pass
# 		timeToNextAction = Utils.rng.randf()*3

func setCharacter(newChar: int) -> void:
	character = newChar
	setCharacterTexture(newChar)


func setName(gikoName: String) -> void:
	$ColorRect/Name.text = gikoName

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
