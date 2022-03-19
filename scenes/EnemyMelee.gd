extends KinematicBody

var health = 2 setget takeDamage, getHealth
onready var Player = get_node("../Player")
onready var playerVars = get_node("/root/PlayerVariables")
enum {
	IDLE,
	COMBAT,
	SEARCHING
}
var direction
var state = IDLE
var velocity = Vector3.ZERO
var speed = 15


func _process(delta):
	match state:
		IDLE:
			direction=Vector3.ZERO
		COMBAT:
			direction = global_transform.origin.direction_to(Player.global_transform.origin)
			velocity = lerp(velocity, direction * speed, delta * 6)
			velocity.y = 0
			velocity = move_and_slide(velocity, Vector3.UP)
	
	if(health<=0):
		queue_free()



func takeDamage(value):
	health -= value
	

func getHealth():
	return health


func _on_Area_body_entered(body):
	if(body.is_in_group("Player")):
		state = COMBAT


func _on_Area_body_exited(body):
	if(body.is_in_group("Player")):
		state = IDLE
