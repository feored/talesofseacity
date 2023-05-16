extends BaseGiko
class_name Giko

#const messagePrefab = preload("res://Giko/Message.tscn")

const MIN_NEXT_MOVE = 5
const MAX_NEXT_MOVE = 10

##var character: int
var NPCID : String = ""
##var displayName : String = ""

var doorInvulnerable = false

var isFollowing = false
var isTargeting = false
var isFleeing = false

var targetTile : Vector2
var targetEndDirection : int
var followTarget : Object

var isFrozen = false

var timeToNextDecision = 0
var timeSinceDecision = 0
var takeDecisionNow = false

##var currentTile = Vector2(0, 0)
##var currentTilePos: Vector2
##var nextTile = Vector2(0, 0)
##var nextTilePosition = Vector2(0, 0)
##var currentDirection = Constants.Directions.DIR_LEFT


var reactionTime = Utils.rng.randfn(3, 1.5)

##var isGhost = true if Utils.rng.randf() > 0.8 else false
##var isMoving = false
##var isSitting = false

var timeElapsed = 0
##var timeSinceAction = Constants.TIME_TO_GHOST if isGhost else Utils.rng.randf() * Constants.TIME_TO_GHOST/2

var currentAction = Constants.Decisions.values() [randi() % Constants.Decisions.size()]

##var currentMessage: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func initializeRandom(name, character) -> void:
	self.character = character
	self.displayName = name
	var isAlreadySeated = true if Utils.rng.randf() > 0.4 else false

	var foundSeat = false
	var startingTile : Vector2
	
	if (isAlreadySeated && Rooms.currentRoomData.has("sit") && Rooms.currentRoomData["sit"].size() > 0):
		for seat in Rooms.currentRoomData["sit"]:
			if (Rooms.getTilePopulation(Vector2(seat["x"], seat["y"]))) < 1:
				startingTile = Vector2(seat["x"], seat["y"])
				foundSeat = true
		
	if !foundSeat:
		startingTile = Rooms.currentRoomWalkableTiles[Utils.rng.randi() % Rooms.currentRoomWalkableTiles.size()]
	self.place(startingTile, Utils.rng.randi() % Constants.Directions.size())

	
	

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
			if (Rooms.getTilePopulation(tile) > 0):
				for giko in Rooms.getGikosOnTile(tile):
					if (is_instance_valid(giko) && (Constants.DIRECTION_VECTOR[giko.currentDirection]) == (self.currentTile - giko.currentTile)):
						## we are facing another giko
						var newDirVector = (giko.currentTile - self.currentTile)
						.faceDirection(Utils.getDirectionFromVector(newDirVector))
						self.timeSinceAction = 0
						break

func startFollowing(giko : Object) -> void:
	self.isFollowing = true
	followTarget = giko
	takeDecisionNow = true

func stopFollowing() -> void:
	self.isFollowing = false

func startFleeing(giko : Object) -> void:
	self.isFleeing = true
	followTarget = giko
	takeDecisionNow = true

func stopFleeing() -> void:
	self.isFleeing = false

func startTargetting(tile: Vector2, endDirection : int = Constants.Directions.DIR_UP):
	self.isTargeting = true
	self.targetTile = tile
	self.targetEndDirection = endDirection
	takeDecisionNow = true

func flee() -> void:
	var currentDistance = Utils.getTileDistance(self.currentTile, followTarget.currentTile)
	for dir in Utils.getValidNearbyDirections(self.currentTile):
		if (Utils.getTileDistance(Utils.getTileCoordsInDirection(self.currentTile, dir), followTarget.currentTile) > currentDistance):
			.move(dir)

func follow() -> void:
	var pathToTarget = findPathToTile(followTarget.currentTile)

	if (pathToTarget.size() < 1):
		#self.isFollowing = false
		return

	var firstTile = pathToTarget[0]
	var firstTileDirection = Vector2(firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)

func goToTarget() -> void:
	var pathToTarget = findPathToTile(targetTile)

	if (pathToTarget.size() < 1):
		self.isTargeting = false
		self.faceDirection(self.targetEndDirection)
		return

	var firstTile = pathToTarget[0]
	var firstTileDirection = Vector2(firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)

func takeDecision() -> void:
	if !self.isMoving && (takeDecisionNow || timeSinceDecision > timeToNextDecision):
		takeDecisionNow = false
		self.destroyMessage()
		if isFleeing:
			flee()
			return
		if isFollowing:
			follow()
			return
		elif isTargeting:
			goToTarget()
			return
		elif self.isNPC:
			idle()
			return
		match currentAction:
			Constants.Decisions.IDLE:
				idle()
			Constants.Decisions.FINDSEAT:
				timeSinceDecision = 0
				timeToNextDecision = Utils.rng.randfn(0.75, 0.25)
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

func talk(message : String = "") -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(5)
	if message == "":
		random_message()
	else:
		spawnMessage(message)

func moveRandom() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(0.75, 0.25)

	var randomWalkableTile = Rooms.currentRoomWalkableTiles[Utils.rng.randi() % Rooms.currentRoomWalkableTiles.size()]
	var pathToSeat = findPathToTile(randomWalkableTile)

	if (pathToSeat.size() < 1):
		return

	var firstTile = pathToSeat[0]
	var firstTileDirection = Vector2(firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)
	return


func changeDirection() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(5)

	var possibleDirections = Constants.Directions.values()
	possibleDirections.erase(self.currentDirection)
	faceDirection(possibleDirections[Utils.rng.randi() % possibleDirections.size()])
	return




func _process(delta):
	if !isDead && !isFrozen:
		## Defines draw order
		#$tile.	text = String(self.currentTile)
		timeElapsed += delta
		self.timeSinceAction += delta
		timeSinceDecision += delta

		if timeElapsed > reactionTime:
			checkReactions()
			timeElapsed = 0

		takeDecision()

		process_movement(delta)
		.checkGhost()


func random_message() -> void:
	self.message(Constants.POSSIBLE_MESSAGES[Utils.rng.randi() % Constants.POSSIBLE_MESSAGES.size()])


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
			position += Utils.getDirectionPixels(self.currentDirection) * delta * State.GIKO_MOVESPEED



func checkDoors() -> void:
	if !doorInvulnerable && Rooms.currentRoomData.has("doors"):
		for door in Rooms.currentRoomData["doors"].keys():
			var currentDoor = Rooms.currentRoomData["doors"][door]
			if currentDoor["target"] != null && currentDoor["x"] == self.currentTile.x && currentDoor["y"] == self.currentTile.y:
				## we are on a door
				if currentDoor["target"]["roomId"] == Rooms.currentRoomId:
					var newDoor = currentDoor["target"]["doorId"]
					self.currentTile = Vector2(Rooms.currentRoomData["doors"][newDoor]["x"], Rooms.currentRoomData["doors"][newDoor]["y"])
					self.currentTilePos = Utils.getTilePosAtCoords(self.currentTile)
					position = self.currentTilePos
					self.isMoving = false

					var zFixedPosition = Utils.getTilePosAtCoords(self.currentTile + Rooms.getZFix(self.currentTile))
					z_index = zFixedPosition.y

					.reanimate()
				else:
					SceneTransition.currentGame.removeRandomGiko(self.get_instance_id())


func freeze() -> void:
	self.isFrozen = true

func unfreeze() -> void:
	self.isFrozen = false

