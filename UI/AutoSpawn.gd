extends ProgressBar

var elapsedTime: float = 0
onready var main = get_node("/root/Main")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = State.autoSpawnTime > 0
	if visible:
		max_value = State.autoSpawnTime
		value = elapsedTime
		
		elapsedTime += delta

		if elapsedTime > State.autoSpawnTime:
			main.spawnRandomGiko()
			elapsedTime = 0
	
