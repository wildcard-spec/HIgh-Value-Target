extends KinematicBody

onready var Player = get_node("../Player")
onready var IK = get_node("../Player/IK_Control")
onready var laser = preload("res://scenes/Laser_projectile_enemy.tscn")
onready var beamSpawn = get_node("EnemyModel/BeamStartPoint")
onready var shootTimer = get_node("ShootTimer")

var health = 2 setget takeDamage, getHealth
var direction
var state = IDLE
var velocity = Vector3.ZERO
var speed = 15
var timerTimeout = false


enum {
	IDLE,
	COMBAT,
	SEARCHING
}

func _process(delta):
	match state:
		IDLE:
			direction=Vector3.ZERO
		COMBAT:
			self.look_at(Player.global_transform.origin, Vector3.UP)
			if(timerTimeout):
				var l = laser.instance()
				beamSpawn.add_child(l)
				l.look_at(Player.global_transform.origin+Vector3(0,1.5,0),Vector3.UP)
				l.shoot = true
				timerTimeout = false
	
	if(health<=0):
		queue_free()



func takeDamage(value):
	health -= value
	

func getHealth():
	return health


func _on_Area_body_entered(body):
	if(body.is_in_group("Player")):
		state = COMBAT
		shootTimer.start()


func _on_Area_body_exited(body):
	if(body.is_in_group("Player")):
		state = IDLE
		shootTimer.stop()


func _on_Timer_timeout():
	timerTimeout = true
