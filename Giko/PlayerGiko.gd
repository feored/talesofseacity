extends AnimatedSprite
class_name PlayerGiko

signal messaged

const messagePrefab = preload("res://Giko/Message.tscn")

var character: int

## funcrefs
var changeRoom: Object
var removeActiveItem: Object

var timeElapsed = 0
var timeSinceAction = 0
var actionAvailable = true

var currentTile = Vector2(0, 0)
var currentTilePos: Vector2
var nextTile = Vector2(0, 0)
var nextTilePosition = Vector2(0, 0)
var currentDirection = Constants.Directions.DIR_LEFT

var isGhost = false
var isMoving = false
var isSitting = false

var currentMessage: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	currentDirection = Constants.Directions.DIR_UP

	play(getRightAnimation())
	setRightFlip()
	set_process_input(true)
	#add_to_group(Constants.GROUP_GIKOS)


func place(startingTile: Vector2, direction: int) -> void:
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
	z_index = position.y
	process_movement(delta)
	timeSinceAction += delta
	checkGhost()


func pickUpItem() -> void:
	timeSinceAction = 0
	## check that we are standing on a tile containing an item
	var currentRoom = Rooms.currentRoomData["id"]
	if Items.ACTIVE_ITEMS.has(currentRoom):
		for activeItem in Items.ACTIVE_ITEMS[currentRoom]:
			if float(activeItem["x"]) == currentTile.x && float(activeItem["y"]) == currentTile.y:
				## successfully picked up item
				Items.addItemInventory(activeItem["id"])
				Items.removeActiveItem(currentRoom, activeItem)
				removeActiveItem.call_func(activeItem)


# func handleInput(delta: float) -> void:
# 	if actionAvailable:
# 		if Input.is_action_pressed("ui_up"):
# 			move(Constants.Directions.DIR_UP)
# 		elif Input.is_action_pressed("ui_down"):
# 			move(Constants.Directions.DIR_DOWN)
# 		elif Input.is_action_pressed("ui_left"):
# 			move(Constants.Directions.DIR_LEFT)
# 		elif Input.is_action_pressed("ui_right"):
# 			move(Constants.Directions.DIR_RIGHT)
# 		elif Input.is_action_pressed("pick_up"):
# 			pickUpItem()

# 	else:
# 		if timeElapsed > Constants.ACTION_TIMEOUT:
# 			actionAvailable = true
# 			timeElapsed = 0
# 		else:
# 			timeElapsed += delta


func try_message() -> void:
	message(Constants.POSSIBLE_MESSAGES[Utils.rng.randi() % Constants.POSSIBLE_MESSAGES.size()])


func process_movement(delta) -> void:
	if isMoving:
		if Utils.isPositionTooFar(position, nextTilePosition, currentDirection):
			# we have arrived at the tile
			position = nextTilePosition
			currentTile = nextTile
			currentTilePos = Utils.getTilePosAtCoords(currentTile)

			checkSitting()
			isMoving = false
			play(getRightAnimation())
			## check if we should change room
			checkDoors()
		else:
			#play(getRightAnimation())
			position += (
				Utils.getDirectionPixels(currentDirection)
				* delta
				* Constants.GIKO_MOVESPEED
			)

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
			if (
				currentDoor["target"] != null
				&& currentDoor["x"] == currentTile.x
				&& currentDoor["y"] == currentTile.y
			):
				## we are on a door
				changeRoom.call_func(currentDoor["target"])
				destroyMessage()
				break


func fixHeightIfSitting() -> void:
	if isSitting:
		position = Vector2(currentTilePos.x, currentTilePos.y - 10)


func getRightAnimation() -> String:
	#fixHeightIfSitting()
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
	timeSinceAction = 0
	if !isMoving:
		actionAvailable = false
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


func _input(event):
	if event.is_action_pressed("ui_up"):
		move(Constants.Directions.DIR_UP)
	elif event.is_action_pressed("ui_down"):
		move(Constants.Directions.DIR_DOWN)
	elif event.is_action_pressed("ui_left"):
		move(Constants.Directions.DIR_LEFT)
	elif event.is_action_pressed("ui_right"):
		move(Constants.Directions.DIR_RIGHT)
	elif event.is_action_pressed("pick_up"):
		pickUpItem()


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
