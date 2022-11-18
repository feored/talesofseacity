extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var HUMAN_MONTHS = {
	Time.MONTH_JANUARY    : "Jan",
	Time.MONTH_FEBRUARY   : "Feb",
	Time.MONTH_MARCH      : "Mar",
	Time.MONTH_APRIL      : "Apr",
	Time.MONTH_MAY        : "May",
	Time.MONTH_JUNE       : "Jun",
	Time.MONTH_JULY       : "Jul",
	Time.MONTH_AUGUST     : "Aug",
	Time.MONTH_SEPTEMBER  : "Sep",
	Time.MONTH_OCTOBER    : "Oct",
	Time.MONTH_NOVEMBER   : "Nov",
	Time.MONTH_DECEMBER   : "Dec"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var time = Time.get_date_dict_from_unix_time(State.date)
	$Label.text = String(time["year"]) + " " + HUMAN_MONTHS[time["month"]] + ", " + String(time["day"])
