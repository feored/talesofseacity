extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var minZoom : float = 0.5
export var maxZoom : float = 2
export var zoomFactor : float = 0.1
export var zoomDuration : float = 0.2

var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera : bool = false

var player

var tween

var _zoomLevel := 1.0 setget _set_zoomLevel


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
			_previousPosition = event.position
			_moveCamera = true
		else:
			_moveCamera = false
	elif event is InputEventMouseMotion && _moveCamera:
		position += ((_previousPosition - event.position) * _zoomLevel)  ## To guarantee we never get out of the frame even on a different zoom level

		position.x = clamp(position.x, Constants.CAMERA_MIN_X, Constants.CAMERA_MAX_X)
		position.y = clamp(position.y, Constants.CAMERA_MIN_Y, Constants.CAMERA_MAX_Y)

		_previousPosition = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		position = player.position

# 	if Input.is_action_just_released("zoom_in"):
# 		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
# 		# call the setter function to use it.
# 		_set_zoomLevel(_zoomLevel - zoomFactor)
# 	if Input.is_action_just_released("zoom_out"):
# 		_set_zoomLevel(_zoomLevel + zoomFactor)
