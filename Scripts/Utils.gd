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

static func getTileDistance(tile : Vector2, secondTile : Vector2) -> float:
        return abs(secondTile.x - tile.x) + abs(secondTile.y - tile.y)

static func getDirectionFromVector(diff : Vector2) -> int:
    match diff:
        Vector2(-1, 0):
            return Constants.Directions.DIR_LEFT
        Vector2(1, 0):
            return Constants.Directions.DIR_RIGHT
        Vector2(0, -1):
            return Constants.Directions.DIR_DOWN
        Vector2(0, 1):
            return Constants.Directions.DIR_UP
        _:
            return Constants.Directions.DIR_UP
    return Constants.Directions.DIR_UP
        

func getValidNearbyDirections(tile : Vector2) -> Array:
    var validDirections = []
    for dir in [Constants.Directions.DIR_LEFT, Constants.Directions.DIR_RIGHT, Constants.Directions.DIR_UP, Constants.Directions.DIR_DOWN]:
        if canMoveInDirection(tile, dir):
            validDirections.push_back(dir)
    return validDirections

func getValidNearbyTiles(tile : Vector2) -> Array:
    var validTiles = []
    for dir in getValidNearbyDirections(tile):
        validTiles.push_back(getTileCoordsInDirection(tile, dir))
    return validTiles

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
    if (Rooms.isTileBlocked(potentialNextTile)):
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


static func makeSimpleDialogue(lines : Array, name : String = "default") -> Dictionary:
    var template = {
        "info" : {
            "requeue" : true,
            "start" : "line0"
        }
    }
    for i in range(lines.size()):
        var id = "line" + String(i)
        template[id] = {
            "id" : id,
            "type" : Constants.LineType.Text,
            "text": lines[i],
        }
        if i != (lines.size() - 1):
            template[id]["nextId"] = "line" + String(i+1)
    return template


static func makeSimpleEnvironmentDialogue(description : Array, canPickup : bool = false, itemId: String = "") -> Dictionary:
    var baseDialogue = makeSimpleDialogue(description)
    if canPickup:
        var lastChoice = {
            "id" : "pickupChoice",
            "type" : Constants.LineType.Choice,
            "choices": 
            [
                {
                    "text": "Pick it up.",
                    "rewards" : [itemId]
                },
                {
                    "text" : "Leave it there."
                }

            ]
        }
        var lastLineId = "line" + String(description.size() - 1)
        baseDialogue[lastLineId]["nextId"] = lastChoice["id"]
        baseDialogue[lastChoice["id"]] = lastChoice
    return baseDialogue

func getRandomDirection() -> int:
    return Constants.Directions.values()[Utils.rng.randi() % Constants.Directions.size()]