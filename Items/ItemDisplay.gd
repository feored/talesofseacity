extends PanelContainer

var item : Dictionary = {}
var showPopup : Object ## funcref
var hidePopup : Object


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setItem(itemData : Dictionary):
	item = itemData
	updatePicture()


func updatePicture() -> void:
	$"TextureRect".texture = load(item["url"])

# func _on_item_hovered_enter() -> void:
# 	showPopup.call_func(item)

# func _on_item_hovered_exit() -> void:
# 	#if not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()):
# 	hidePopup.call_func()


func _on_TextureRect_mouse_entered():
	showPopup.call_func(item)

func _on_TextureRect_mouse_exited():
	hidePopup.call_func()
