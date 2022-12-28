extends AnimatedSprite
class_name BaseGiko

const messagePrefab = preload("res://Giko/Message.tscn")


var character: int
var displayName : String = ""

var texturesLoaded = false

var currentTilePos: Vector2
var currentTile          = Vector2(0, 0)
var nextTile            = Vector2(0, 0)
var nextTilePosition    = Vector2(0, 0)
var currentDirection    = Constants.Directions.DIR_LEFT

var timeSinceAction     = 0


var isGhost : bool      = false
var isMoving : bool     = false
var isSitting : bool    = false
var isNPC : bool        = false

var currentMessage: Node

func _ready():
    setCharacter(character)
    setName(displayName)
    reanimate()

func setCharacter(newChar: int) -> void:
    character = newChar
    setCharacterTexture(newChar)


func setName(gikoName: String) -> void:
    if "◆" in displayName:
        var nameSplit = displayName.split("◆")
        $"%Name".text = nameSplit[0]
        $"%TripSymbol".visible = true
        $"%TripCode".text = nameSplit[1]
        $"%TripCode".visible = true
    else:
        $"%Name".text = displayName
    if self.character == Constants.Character.Shiinigami:
        $Control.rect_position.x -= 20

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

func move(toDirection: int) -> void:
    if Utils.canMoveInDirection(currentTile, toDirection):
        timeSinceAction = 0
        nextTile = Utils.getTileCoordsInDirection(currentTile, toDirection)

        currentDirection = toDirection
        nextTilePosition = Utils.getTilePosAtCoords(nextTile)

        isMoving = true
        setRightFlip()
        play(getRightAnimation())
        Rooms.updateGikoPosition(self, nextTile, currentTile)
            
            

func setRightFlip() -> void:
    if (
        currentDirection == Constants.Directions.DIR_LEFT
        or currentDirection == Constants.Directions.DIR_DOWN
    ):
        flip_h = true
    else:
        flip_h = false

func setCharacterTexture(newCharacter : int) -> void:
    var newCharacterPath = "res://Characters/" + Constants.CHARACTERS[newCharacter] + "/"

    var backStanding = load(newCharacterPath + Constants.GIKOANIM_BACK_STANDING + ".png")
    var frontStanding = load(newCharacterPath + Constants.GIKOANIM_FRONT_STANDING + ".png")

    var backSitting = load(newCharacterPath + Constants.GIKOANIM_BACK_SITTING + ".png")
    var frontSitting = load(newCharacterPath + Constants.GIKOANIM_FRONT_SITTING + ".png")

    var backWalking1 = load(newCharacterPath + Constants.GIKOANIM_BACK_WALKING + "-1" + ".png")
    var backWalking2 = load(newCharacterPath + Constants.GIKOANIM_BACK_WALKING + "-2" + ".png")

    var frontWalking1 = load(newCharacterPath + Constants.GIKOANIM_FRONT_WALKING + "-1" + ".png")
    var frontWalking2 = load(newCharacterPath + Constants.GIKOANIM_FRONT_WALKING + "-2" + ".png")

    # if frames != null:
    # 	frames.free()
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
    
    texturesLoaded = true



func reanimate() -> void:
    var zFixedPosition = Utils.getTilePosAtCoords(self.currentTile + Rooms.getZFix(self.currentTile))
    z_index = zFixedPosition.y
    checkSitting()
    setRightFlip()
    if texturesLoaded:
        play(getRightAnimation())
    

func place(startingTile: Vector2, direction: int) -> void:
    currentTile = startingTile
    currentTilePos = Utils.getTilePosAtCoords(currentTile)
    position = Utils.getTilePosAtCoords(currentTile)
    currentDirection = direction
    Rooms.updateGikoPosition(self, startingTile)
    reanimate()

func message(text) -> void:
    spawnMessage(text)


func spawnMessage(text) -> void:
    self.timeSinceAction = 0
    self.currentMessage = self.messagePrefab.instance()
    self.currentMessage.setMessage(text)
    Log.addLog(self.displayName, text)
    $MessageRoot.add_child(self.currentMessage)


func destroyMessage() -> void:
    self.timeSinceAction = 0
    if self.currentMessage != null:
        self.currentMessage.delete()
        self.currentMessage = null
    
