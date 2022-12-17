extends BaseGiko
class_name Giko

#const messagePrefab = preload("res://Giko/Message.tscn")

const MIN_NEXT_MOVE = 5
const MAX_NEXT_MOVE = 10

##var character: int

var NPCID : String = ""
##var displayName : String = ""

var isFollowing = false
var isTargeting = false
var targetTile : Vector2

var timeToNextDecision = 0
var timeSinceDecision = 0

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
	.setCharacter(character)
	.setName(name)
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
	.place(startingTile, Utils.rng.randi() % Constants.Directions.size())

	
	

func initializeNPC(activeNPCData) -> void:
	self.isNPC = true
	NPCID = activeNPCData["id"]

	var NPCData = NPCs.NPCs[NPCID]
	.setCharacter(NPCData["character"])
	.setName(NPCData["name"])

	var startingTile = Vector2(float(activeNPCData["x"]), float(activeNPCData["y"]))
	.place(startingTile, activeNPCData["direction"])



func findEmptySeat(nearest = false) -> Vector2:
	if (!Rooms.currentRoomData.has("sit") or Rooms.currentRoomData["sit"].size() < 1):
		return self.currentTile

	var emptySeats = []
	for seat in Rooms.currentRoomData["sit"]:
		var currentSeat = Vector2(seat["x"], seat["y"])
		if (Rooms.getTilePopulation(currentSeat) == 0):
			emptySeats.push_back(currentSeat)
	
	if emptySeats.size() == 0:
		return self.currentTile
	
	if nearest:
		var closestEmptySeat = emptySeats[0]
		var closestDiff = Utils.getTileDistance(self.currentTile, closestEmptySeat)
		for currentSeat in emptySeats:
			if (Rooms.getTilePopulation(currentSeat) == 0):
				var diff = Utils.getTileDistance(self.currentTile, currentSeat)
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

	cameFrom[self.currentTile] = null
	costSoFar[self.currentTile] = 0

	openTiles[self.currentTile] = 0

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
	while current != self.currentTile:
		path.push_back(current)
		current = cameFrom[current]
	path.invert()

	return path
		

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
						faceDirection(Utils.getDirectionFromVector(newDirVector))
						break


func faceDirection(newDirection : int) -> void:
	self.currentDirection = newDirection
	self.timeSinceAction = 0
	.reanimate()

func follow() -> void:
	pass

func goToTarget() -> void:
	var pathToTarget = findPathToTile(targetTile)

	if (pathToTarget.size() < 1):
		return

	var firstTile = pathToTarget[0]
	var firstTileDirection = Vector2(firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)

func takeDecision() -> void:
	if !self.isMoving && timeSinceDecision > timeToNextDecision:
		self.destroyMessage()
		if self.isNPC:
			if isFollowing:
				follow()
			elif isTargeting:
				goToTarget()
			else:
				idle()
			return
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
	random_message()

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

func findSeat() -> void:
	timeSinceDecision = 0
	timeToNextDecision = Utils.rng.randfn(0.75, 0.25)

	var randomSeat = findEmptySeat()
	var pathToSeat = findPathToTile(randomSeat)

	if (pathToSeat.size() < 1):
		return

	var firstTile = pathToSeat[0]
	var firstTileDirection = Vector2(firstTile.x - self.currentTile.x, firstTile.y - self.currentTile.y)
	var directionToTake = Utils.getDirectionFromVector(firstTileDirection)
	.move(directionToTake)
	return



func _process(delta):
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
			position += Utils.getDirectionPixels(self.currentDirection) * delta * Constants.GIKO_MOVESPEED



func checkDoors() -> void:
	if Rooms.currentRoomData.has("doors"):
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
					Rooms.removeGiko(self, self.currentTile)


func getRandomDirection() -> int:
	return Constants.Directions.values()[Utils.rng.randi() % Constants.Directions.size()]


