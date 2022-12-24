extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var minZoom : float = 0.5
export var maxZoom : float = 2
export var zoomFactor : float = 0.1
export var zoomDuration : float = 0.2


export var shakePower = 4
export var shakeTime = 0.4
var isShaking = false
var elapsedtime = 0

var playerOffset : Vector2

var _previousOffset: Vector2 = Vector2(0, 0)
var _moveCamera : bool = false

var player

var tween

var _zoomLevel := zoom.x setget _set_zoomLevel


func _set_zoomLevel(value: float) -> void:
    # We limit the value between `min_zoom` and `max_zoom`
    _zoomLevel = clamp(value, minZoom, maxZoom)
    # Then, we ask the tween node to animate the camera's `zoom` property from its current value
    # to the target zoom level.
    if tween:
        tween.stop()
    tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "zoom", Vector2(_zoomLevel, _zoomLevel), zoomDuration)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


func _unhandled_input(event):
    if event.is_action_released("zoom_in"):
        # Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
        # call the setter function to use it.
        _set_zoomLevel(_zoomLevel - zoomFactor)
    elif event.is_action_released("zoom_out"):
        _set_zoomLevel(_zoomLevel + zoomFactor)

    if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
        if event.is_pressed():
            _previousOffset = event.position
            _moveCamera = true
        else:
            _moveCamera = false
    elif event is InputEventMouseMotion && _moveCamera:
        playerOffset += ((_previousOffset - event.position) * _zoomLevel)  ## To guarantee we never get out of the frame even on a different zoom level

        playerOffset.x = clamp(playerOffset.x, Constants.CAMERA_MIN_X, Constants.CAMERA_MAX_X)
        playerOffset.y = clamp(playerOffset.y, Constants.CAMERA_MIN_Y, Constants.CAMERA_MAX_Y)

        _previousOffset = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if player != null:
        position = player.position + playerOffset
    if isShaking:
        if elapsedtime < shakeTime:
            offset =  Vector2(Utils.rng.randf(), Utils.rng.randf()) * shakePower
            elapsedtime += delta
        else:
            isShaking = false
            elapsedtime = 0

func shake(duration : float = 0, power : float = 0):
    shakeTime = duration if duration > 0 else shakeTime
    shakePower = power if power > 0 else shakePower
    isShaking = true

# 	if Input.is_action_just_released("zoom_in"):
# 		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
# 		# call the setter function to use it.
# 		_set_zoomLevel(_zoomLevel - zoomFactor)
# 	if Input.is_action_just_released("zoom_out"):
# 		_set_zoomLevel(_zoomLevel + zoomFactor)
