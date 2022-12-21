extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MAX_PARTICLES = 500
const MAX_RADIUS = 7.5
const AVG_SPEED = 100
onready var dimensions = Vector2(1920, 1080)
onready var zoom = $"%Camera2D".zoom
var particles = []
var angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(MAX_PARTICLES):
		particles.push_back(
			{
				"pos" :  Vector2(
					(Utils.rng.randf() * dimensions.x)  - dimensions.x/2,
					(Utils.rng.randf() * dimensions.y) - dimensions.y
				),
				"size" : Utils.rng.randf() * MAX_RADIUS,
				"speed" : Utils.rng.randfn(AVG_SPEED, 25),
				"angle" : Utils.rng.randfn(0, 1),
				"offset" : Utils.rng.randfn(0, TAU)
			}
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zoom = $"%Camera2D".zoom
	angle += delta
	for p in particles:
		p["pos"].x += delta * p["speed"]/5 * cos(angle + p["offset"]) * p["angle"]
		p["pos"].y += delta * p["speed"]
		if p["pos"].y > dimensions.y:
			p["pos"] = Vector2(p["pos"].x, - dimensions.y)
	update()


func _draw():
	#print(particles[0]["pos"].x * (1/zoom.x))
	for p in particles:
		draw_circle(Vector2(p["pos"].x * (zoom.x), p["pos"].y * (zoom.y)), (p["size"] * (zoom.x)), Color.white)
