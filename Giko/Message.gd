extends Control

var duration = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$MarginContainer.add_constant_override("margin_left", 14)
	## Decide if this message got a GikoCoin
	#if State.rng.randf() < State.GIKOCOIN_CHANCE:
	#	$GikoCoin.show()


func setMessage(newMessage):
	var label = $"%Label"
	label.text = newMessage
	if newMessage.length() > 30:
		rect_size.x = 200
		label.autowrap = true
	else:
		label.autowrap = false
		rect_size.x = 50
	$Polygon2D.position.y = rect_size.y - 4
	#label.rect_size = label.get_font("").get_string_size(label.text)
	#rect_size = Vector2($Label.rect_size.x + 14, $Label.rect_size.y)
	#rect_size = $Label.rect_size

func delete():
    queue_free()