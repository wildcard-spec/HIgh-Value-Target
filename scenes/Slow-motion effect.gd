extends Node

onready var playerVars = get_node("/root/PlayerVariables")

const END_VALUE = 1
var is_active = false
var time_start
var duration_ms
var start_value

func start(duration = 1, strength = 0.6):
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1-strength
	Engine.time_scale = start_value
	is_active = true
	
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		start()
		playerVars.is_time_slowed = true
	if is_active:
		var current_time = OS.get_ticks_msec()-time_start
		var value = circle_ease_in(current_time, start_value, END_VALUE, duration_ms)
	#	var value = cubic_ease_out(current_time, start_value, END_VALUE, duration_ms)
		if current_time >= duration_ms:
			is_active = false
			value = END_VALUE
			playerVars.is_time_slowed = false
		Engine.time_scale = value
	
#t:current time
#b: start time
#c: end value
#d: duration
func circle_ease_in(t,b,c,d):
	t /= d
	return -c * (sqrt(1-t*t)-1)+b
 
func cubic_ease_in(t, d):
	t /= d
	return t*t*t

func cubic_ease_out(t,b,c,d):
	t /= d
	return c - pow(c-t, 3)
