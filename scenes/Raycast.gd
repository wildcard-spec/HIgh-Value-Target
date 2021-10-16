tool
extends StaticBody


onready var Player = get_node("../Character/Player")
var collision
onready var Box = get_node("../Box")
onready var Gizmo = get_node("../Character/Player/Gizmo")
var gizmoPos
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("castRay"):
		var normVector = Player.global_transform.origin.direction_to(Box.global_transform.origin)
		var playerDirection = Player.transform.basis.x+Player.transform.basis.y+Player.transform.basis.z
		var forwardDirection = Player.global_transform.basis.z
		var degrees = forwardDirection.angle_to(normVector) * 57.2958
		#if (collision.position.dot(Player.global_transform.basis.z) > 0):
		print("Normalized Vector =" + str(normVector))
		print("Player Direction =" + str(playerDirection))
		print("Forward Direction =" + str(forwardDirection))
		print("Degrees = " + str(degrees))
		print("Tranform basis y = " + str(Player.transform))
		var ray = normVector.dot(playerDirection)
		Gizmo.global_transform.origin = Player.global_transform.origin + normVector
		print(ray)
		if(ray>0):
			if(normVector[0]>0):
				print("Right")
			else:
				print("Left")
		
