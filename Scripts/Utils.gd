extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


static func getNearbyTiles(tile : Vector2) -> Array:
	return [
		getTileCoordsInDirection(tile, Constants.Directions.DIR_LEFT),
		getTileCoordsInDirection(tile, Constants.Directions.DIR_RIGHT),
		getTileCoordsInDirection(tile, Constants.Directions.DIR_UP),
		getTileCoordsInDirection(tile, Constants.Directions.DIR_DOWN),
	]


func getValidNearbyDirections(tile : Vector2) -> Array:
	var validDirections = []
	for dir in [Constants.Directions.DIR_LEFT, Constants.Directions.DIR_RIGHT, Constants.Directions.DIR_UP, Constants.Directions.DIR_DOWN]:
		if canMoveInDirection(tile, dir):
			validDirections.push_back(dir)
	return validDirections


static func getTilePosAtCoords(coords : Vector2) -> Vector2:
	return Vector2(
		(coords.x + coords.y) * Rooms.GRID_STEP_X,
		(coords.x - coords.y) * Rooms.GRID_STEP_Y
	)

func canMoveInDirection(currentTile : Vector2, toDirection: int) -> bool:
	var potentialNextTile = Utils.getTileCoordsInDirection(currentTile, toDirection)
	if (!Rooms.isTileInBounds(potentialNextTile)):
		return false
	#TODO make room data more easily parsable than a dict..
	if (Rooms.currentRoomData.has("blocked")):
		for blockedTile in Rooms.currentRoomData["blocked"]:
			if (float(blockedTile["x"]) == potentialNextTile.x && float(blockedTile["y"]) == potentialNextTile.y):
				return false
	if (Rooms.currentRoomData.has("forbiddenMovements")):
		for movement in Rooms.currentRoomData["forbiddenMovements"]:
			if (
				movement["xFrom"] 	== currentTile.x &&
				movement["yFrom"] 	== currentTile.y &&
				movement["xTo"] 	== potentialNextTile.x &&
				movement["yTo"]   	== potentialNextTile.y
			):
				return false
	return true
	
static func posToTile(pos: Vector2) -> Vector2:
	return Vector2(
		(pos.x / Rooms.GRID_STEP_X + pos.y / Rooms.GRID_STEP_Y) / 2,
		(pos.y / Rooms.GRID_STEP_Y - (pos.x / Rooms.GRID_STEP_X)) /2
	)

static func isPositionTooFar(pos : Vector2, tilePos: Vector2, direction : int) -> bool:
	var isTooFar : bool = false
	match direction:
		Constants.Directions.DIR_LEFT:
			if pos.x < tilePos.x or pos.y < tilePos.y:
				isTooFar = true
		Constants.Directions.DIR_RIGHT:
			if pos.x > tilePos.x or pos.y > tilePos.y:
				isTooFar = true
		Constants.Directions.DIR_UP:
			if pos.x > tilePos.x or pos.y < tilePos.y:
				isTooFar = true
		Constants.Directions.DIR_DOWN:
			if pos.x < tilePos.x or pos.y > tilePos.y:
				isTooFar = true
				
	return isTooFar

static func getTileCoordsInDirection(tile : Vector2, newDir : int) -> Vector2:
	return tile + Constants.DIRECTION_VECTOR[newDir]


func getDirectionPixels(currentDirection : int) -> Vector2:
	var pixels: Vector2

	match currentDirection:
		Constants.Directions.DIR_LEFT:
			pixels = Vector2(-1, -Rooms.GRID_STEP_Y/Rooms.GRID_STEP_X)
		Constants.Directions.DIR_RIGHT:
			pixels = Vector2(1, Rooms.GRID_STEP_Y/Rooms.GRID_STEP_X)
		Constants.Directions.DIR_UP:
			pixels = Vector2(1, -Rooms.GRID_STEP_Y/Rooms.GRID_STEP_X)
		Constants.Directions.DIR_DOWN:
			pixels = Vector2(-1, Rooms.GRID_STEP_Y/Rooms.GRID_STEP_X)

	return pixels


func roomDirectionToEnum(direction : String) -> int:
	var resultDirection : int = Constants.Directions.DIR_DOWN

	match direction:
		"down":
			resultDirection = Constants.Directions.DIR_DOWN
		"right":
			resultDirection = Constants.Directions.DIR_RIGHT
		"up":
			resultDirection = Constants.Directions.DIR_UP
		"left":
			resultDirection = Constants.Directions.DIR_LEFT
	
	return resultDirection
