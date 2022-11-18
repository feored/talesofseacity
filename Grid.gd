extends Node2D


func _ready():
	pass


func _draw():
	draw_grid()
	pass


func draw_grid() -> void:
	## Only draw center of every tile
	for i in range(0, Rooms.currentRoomData["size"]["x"]):
		for j in range(0, Rooms.currentRoomData["size"]["y"]):
			draw_tile(Vector2(i, j))




func draw_tile(tile: Vector2) -> void:
	var new_label = Label.new()
	var tilePos = Utils.getTilePosAtCoords(tile)
	new_label.text = String(tile)
	new_label.add_color_override("font_color", Color.red)
	add_child(new_label)
	new_label.rect_position = tilePos
	draw_circle(tilePos, 5, Color.black)
	# var tileStatus = getValueGridObject(tile)
	# match tileStatus:
	# 	Constants.TileStatus.FREE:
	#
	# 	Constants.TileStatus.SEAT:
	# 		draw_circle(tilePos, 5, Color.green)
	# 	Constants.TileStatus.BLOCKED:
	# 		draw_circle(tilePos, 20, Color.red)


func _process(delta):
	pass
