extends BaseGiko
class_name PlayerGiko

## funcrefs
var changeRoom: Object
var removeActiveItem: Object
var talkToNPC : Object
var talkToEnvironment : Object
var canInteract : Object

var timeElapsed = 0
var actionAvailable = true


# Called when the node enters the scene tree for the first time.
func _ready():
	self.currentDirection = Constants.Directions.DIR_UP
	.reanimate()
	set_process_input(true)


func _process(delta):
	process_movement(delta)
	self.timeSinceAction += delta
	.checkGhost()


func tryPickUpItem() -> bool:
	## check that we are standing on a tile containing an item
	var successPickedUp = false
	var currentRoom = Rooms.currentRoomData["id"]
	if Items.ACTIVE_ITEMS.has(currentRoom):
		for activeItem in Items.ACTIVE_ITEMS[currentRoom]:
			if float(activeItem["x"]) == self.currentTile.x && float(activeItem["y"]) == self.currentTile.y:
				self.timeSinceAction = 0
				successPickedUp = true
				## successfully picked up item
				Items.addItemInventory(activeItem["id"])
				Items.removeActiveItemAtPosition(currentRoom, activeItem["id"], self.currentTile)
				removeActiveItem.call_func(activeItem)
	return successPickedUp


func process_movement(delta) -> void:
	if isMoving:
		if Utils.isPositionTooFar(position, self.nextTilePosition, self.currentDirection):
			# we have arrived at the tile
			position = self.nextTilePosition
			self.currentTile = self.nextTile
			self.currentTilePos = Utils.getTilePosAtCoords(self.currentTile)
			

			self.isMoving = false
			.reanimate()
			## check if we should change room
			checkDoors()
		else:
			position += (
				Utils.getDirectionPixels(currentDirection)
				* delta
				* State.GIKO_MOVESPEED
			)

func checkDoors() -> void:
	if Rooms.currentRoomData.has("doors"):
		for door in Rooms.currentRoomData["doors"].keys():
			var currentDoor = Rooms.currentRoomData["doors"][door]
			if (
				currentDoor["target"] != null
				&& currentDoor["x"] == self.currentTile.x
				&& currentDoor["y"] == self.currentTile.y
			):
				## we are on a door
				if (currentDoor["target"]["roomId"] == Rooms.currentRoomId):
					var newDoor = Rooms.currentRoomData["doors"][currentDoor["target"]["doorId"]]
					.place(Vector2(newDoor["x"], newDoor["y"]), Utils.roomDirectionToEnum(newDoor["direction"]))
					.reanimate()
				else:
					changeRoom.call_func(currentDoor["target"])
					self.destroyMessage()
				break



func try_move(toDirection: int) -> void:
	self.timeSinceAction = 0
	if !isMoving:
		actionAvailable = false
		if self.currentDirection != toDirection:
			self.currentDirection = toDirection
			.reanimate()
		else:
			.move(toDirection)

func interact() -> void:
	## priority is remove text messages
	if canInteract.call_func():
		## priority is talk to NPC, then try to pick up item, then interact with environment
		var frontTile = Utils.getTileCoordsInDirection(self.currentTile, self.currentDirection)
		var gikosOnTile = Rooms.getGikosOnTile(frontTile)
		var gikoNPC = null
		for giko in gikosOnTile:
			if giko != self && giko.isNPC:
				gikoNPC = giko
				break
		if gikoNPC != null:
			talkToNPC.call_func(gikoNPC.NPCID)
		else:
			var pickedUp = tryPickUpItem()
			if !pickedUp:
				talkToEnvironment.call_func(frontTile)
			
func freeze() -> void:
	self.frozen = true

func unfreeze() -> void:
	self.frozen = false

func _input(event):
	if event.is_action_pressed("debug"):
		get_node("/root/Main").popRandomGiko()
	if State.PAUSE :
		if event.is_action_pressed("interact"):
			interact()
	else:  
		if event.is_action_pressed("ui_up", true):
			try_move(Constants.Directions.DIR_UP)
		elif event.is_action_pressed("ui_down", true):
			try_move(Constants.Directions.DIR_DOWN)
		elif event.is_action_pressed("ui_left", true):
			try_move(Constants.Directions.DIR_LEFT)
		elif event.is_action_pressed("ui_right", true):
			try_move(Constants.Directions.DIR_RIGHT)
		elif event.is_action_pressed("interact"):
			interact()

