extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateServerSize(State.serverSize)
	updateActivity(State.totalActivity)


func updateGikos(newValue : int) -> void:
	$Container/Gikos/Amount.text = str(newValue)

func updateActivity(newValue : int) -> void:
	$Container/Activity/Amount.text = str(newValue)

func updateCoins(newValue : int) -> void:
	$Container/Coins/Amount.text = str(newValue)

func updateServerSize(newValue : int) -> void:
	$Container/Gikos/maxAmount.text = str(newValue)
