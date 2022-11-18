extends AnimatedSprite
class_name PlayerGiko

signal messaged
signal died

const messagePrefab = preload("res://Giko/Message.tscn")

const MIN_NEXT_MOVE = 5
const MAX_NEXT_MOVE = 10

var character: int

## Funcrefs
var getTilePopulation: Object
var getTileStatus: Object
var removePosition: Object

var changeRoom: Object

var timeElapsed = 0

var currentTile = Vector2(5, 5)
var currentTilePos: Vector2
var nextTile = Vector2(0, 0)
var nextTilePosition = Vector2(0, 0)
var currentDirection = Constants.Directions.DIR_LEFT

var timeToNextAction: int
var isMoving = false
var isSitting = false
var isDead = false

var currentMessage: Node

var timeToNextMood: int
var currentMood: int

var execMood: Object
var endMood: Object
var canTakeAction: Object
var currentMoodData = {}

var life = 90

const GHOST_COLOR = Color(1, 1, 1, 0.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	currentDirection = Constants.Directions.DIR_UP

	play(getRightAnimation())
	setRightFlip()
	#add_to_group(Constants.GROUP_GIKOS)


func place(startingTile: Vector2, direction : int) -> void:
	currentTile = startingTile
	currentTilePos = Utils.getTilePosAtCoords(currentTile)
	position = Utils.getTilePosAtCoords(currentTile)
	currentDirection = direction
	play(getRightAnimation())
	setRightFlip()


func setCharacter(newChar: int) -> void:
	character = newChar
	setCharacterTexture(newChar)


func setName(gikoName: String) -> void:
	$ColorRect/Name.text = gikoName


func _process(delta):
	## Defines draw order
	#$tile.	text = String(currentTile)
	timeElapsed += delta
	if !isDead:
		handleInput()
		process_movement(delta)


func handleInput() -> void:
	if Input.is_action_pressed("ui_up"):
		move(Constants.Directions.DIR_UP)
	elif Input.is_action_pressed("ui_down"):
		move(Constants.Directions.DIR_DOWN)
	elif Input.is_action_pressed("ui_left"):
		move(Constants.Directions.DIR_LEFT)
	elif Input.is_action_pressed("ui_right"):
		move(Constants.Directions.DIR_RIGHT)


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
			## check if we should change room
			if Rooms.currentRoomData.has("doors"):
				for door in Rooms.currentRoomData["doors"].keys():
					var currentDoor = Rooms.currentRoomData["doors"][door]
					if currentDoor["x"] == currentTile.x && currentDoor["y"] == currentTile.y:
						## we are on a door
						changeRoom.call_func(currentDoor["target"])
						isDead = true
						queue_free()
						break

		else:
			#play(getRightAnimation())
			position += (
				Utils.getDirectionPixels(currentDirection)
				* delta
				* Constants.GIKO_MOVESPEED
			)


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

	if !isMoving:
		if currentDirection != toDirection:
			currentDirection = toDirection
			play(getRightAnimation())
			setRightFlip()
		elif Utils.canMoveInDirection(currentTile, toDirection):
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
