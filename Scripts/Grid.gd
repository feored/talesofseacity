extends Node2D

const DRAW_GRID = false


func _ready():
    pass


func _draw():
    if DRAW_GRID:
        for i in range(0, Rooms.currentRoomData["size"]["x"]):
            for j in range(0, Rooms.currentRoomData["size"]["y"]):
                var tilePos = Utils.getTilePosAtCoords(Vector2(i,j))
                draw_circle(tilePos, 2, Color.black)


func draw_grid() -> void:
    if DRAW_GRID:
        update()
        clear_grid()
        ## Only draw center of every tile
        for i in range(0, Rooms.currentRoomData["size"]["x"]):
            for j in range(0, Rooms.currentRoomData["size"]["y"]):
                draw_tile(Vector2(i, j))


func clear_grid() -> void:
    if DRAW_GRID:
        for node in get_children():
            node.queue_free()



func draw_tile(tile: Vector2) -> void:
    var new_label = Label.new()
    var tilePos = Utils.getTilePosAtCoords(tile)
    new_label.text = String(tile)
    new_label.add_color_override("font_color", Color.red)
    add_child(new_label)
    new_label.rect_position = tilePos

func _process(delta):
    pass
