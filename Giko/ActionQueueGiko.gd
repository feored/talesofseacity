extends BaseGiko
class_name ActionQueueGiko

##var character: int
var NPCID: String = ""
##var displayName : String = ""

var doorInvulnerable = false

var isFrozen = false

var timeElapsed = 0

#var reactionTime = Utils.rng.randfn(3, 1.5)

var refreshActionsTimeElapsed = 0
var refreshActionsTimer = 0.5

var actionQueue = []
var currentActionTimeElapsed = 0

var hasReactions = false


func initializeAction(newAction) -> void:
	currentActionTimeElapsed = 0
	performAction(newAction)


func addAction(newAction) -> void:
	actionQueue.push_back(newAction)


func addMultipleActions(actions: Array) -> void:
	for action in actions:
		addAction(action)


# Called when the node enters the scene tree for the first time.
func _ready():
	if self.actionQueue.size() > 0:
		initializeAction(self.actionQueue[0])


func initializeNPC(activeNPCData) -> void:
	self.isNPC = true
	NPCID = activeNPCData["id"]

	var NPCData = NPCs.NPCs[NPCID]
	self.character = NPCData["character"]
	self.displayName = NPCData["name"]

	var startingTile = Vector2(float(activeNPCData["x"]), float(activeNPCData["y"]))
	.place(startingTile, activeNPCData["direction"])


func checkReactions() -> void:
	## check for reactions eg. facing someone
	## staring at us
	if !self.isMoving && !self.isGhost:
		for tile in Utils.getNearbyTiles(self.currentTile):
			if Rooms.getTilePopulation(tile) > 0:
				for giko in Rooms.getGikosOnTile(tile):
					if (
						is_instance_valid(giko)
						&& (
							(Constants.DIRECTION_VECTOR[giko.currentDirection])
							== (self.currentTile - giko.currentTile)
						)
					):
						## we are facing another giko
						var newDirVector = giko.currentTile - self.currentTile
						.faceDirection(Utils.getDirectionFromVector(newDirVector))
						break


func flee(targetGiko) -> void:
	var currentDistance = Utils.getTileDistance(self.currentTile, targetGiko.currentTile)
	for dir in Utils.getValidNearbyDirections(self.currentTile):
		if (
			Utils.getTileDistance(
				Utils.getTileCoordsInDirection(self.currentTile, dir), targetGiko.currentTile
			)
			> currentDistance
		):
			.move(dir)


func follow(targetGiko) -> void:
	var pathToTarget = Utils.findPathToTile(self.currentTile, targetGiko.currentTile)

	if pathToTarget.size() < 1:
		#self.isFollowing = false
		return

	var firstTile = pathToTarget[0]
	var firstTileDirection = Vector2(
		firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y
	)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)


func goToTarget(targetTile) -> void:
	var pathToTarget = Utils.findPathToTile(self.currentTile, targetTile)

	if pathToTarget.size() < 1:
		return

	var firstTile = pathToTarget[0]
	var firstTileDirection = Vector2(
		firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y
	)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)


func checkActionIsOver(currentAction) -> bool:
	if currentAction["isTimed"] == true:
		return currentActionTimeElapsed > currentAction["maxTime"]
	match currentAction["type"]:
		Constants.Actions.FACE:
			return true
		Constants.Actions.IDLE:
			return true
		Constants.Actions.TALK:
			return true
		Constants.Actions.MOVE:
			return currentAction["target"] == self.currentTile
		Constants.Actions.FOLLOW:
			return false
		Constants.Actions.FLEE:
			return false
		_:
			return false


func performAction(action) -> void:
	match action["type"]:
		Constants.Actions.FACE:
			.faceDirection(action["target"])
		Constants.Actions.IDLE:
			pass
		Constants.Actions.TALK:
			.spawnMessage(action["target"])
		Constants.Actions.MOVE:
			goToTarget(action["target"])
		Constants.Actions.FOLLOW:
			### need to pass NPC ID and look for giko in scene at runtime
			follow(action["target"])
		Constants.Actions.FLEE:
			### need to pass NPC ID and look for giko in scene at runtime
			flee(action["target"])


func processCurrentAction() -> void:
	if self.actionQueue.size() < 1:
		return
	if checkActionIsOver(self.actionQueue[0]):
		.destroyMessage()
		self.actionQueue.pop_front()
		if self.actionQueue.size() > 0:
			self.initializeAction(self.actionQueue[0])
	else:
		performAction(self.actionQueue[0])


func _process(delta):
	if !isDead && !isFrozen:
		if hasReactions:
			checkReactions()

		currentActionTimeElapsed += delta

		refreshActionsTimeElapsed += delta
		if refreshActionsTimeElapsed > refreshActionsTimer:
			refreshActionsTimeElapsed = 0
			processCurrentAction()

		process_movement(delta)
		.checkGhost()


func process_movement(delta) -> void:
	if self.isMoving:
		if Utils.isPositionTooFar(position, self.nextTilePosition, self.currentDirection):
			# we have arrived at the tile

			position = self.nextTilePosition
			self.currentTile = self.nextTile
			self.currentTilePos = Utils.getTilePosAtCoords(self.currentTile)
			self.isMoving = false

			.reanimate()
			checkDoors()
		else:
			position += (
				Utils.getDirectionPixels(self.currentDirection)
				* delta
				* State.GIKO_MOVESPEED
			)


func checkDoors() -> void:
	if !doorInvulnerable && Rooms.currentRoomData.has("doors"):
		for door in Rooms.currentRoomData["doors"].keys():
			var currentDoor = Rooms.currentRoomData["doors"][door]
			if (
				currentDoor["target"] != null
				&& currentDoor["x"] == self.currentTile.x
				&& currentDoor["y"] == self.currentTile.y
			):
				## we are on a door
				if currentDoor["target"]["roomId"] == Rooms.currentRoomId:
					var newDoor = currentDoor["target"]["doorId"]
					self.currentTile = Vector2(
						Rooms.currentRoomData["doors"][newDoor]["x"],
						Rooms.currentRoomData["doors"][newDoor]["y"]
					)
					self.currentTilePos = Utils.getTilePosAtCoords(self.currentTile)
					position = self.currentTilePos
					self.isMoving = false

					var zFixedPosition = Utils.getTilePosAtCoords(
						self.currentTile + Rooms.getZFix(self.currentTile)
					)
					z_index = zFixedPosition.y

					.reanimate()
				else:
					.disappear()


func freeze() -> void:
	self.isFrozen = true


func unfreeze() -> void:
	self.isFrozen = false
