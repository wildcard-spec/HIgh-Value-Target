extends Spatial


# Declare member variables here. Examples:
onready var Player = get_parent().get_node("Player")
onready var Enemy = get_parent().get_node("Enemy")
onready var IK = Player.get_node("IK_Control")
onready var indicator = Player.get_node("player_model/Indicator")
onready var array1 = IK.leftHandArray
onready var array2 = IK.rightHandArray
onready var array3 = IK.akimboArray
onready var targetLeft = IK.targetLeft
onready var targetRight = IK.targetRight
onready var default_left = IK.default_left
onready var restLeft = IK.restLeft

# Called when the node enters the scene tree for the first time.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#	if Input.is_action_just_pressed("debug"):
	#	indicator.hide()
#	if Input.is_action_just_pressed("castRay"):
#		indicator.show()
#		print("Basis =" + str(Player.global_transform.basis))
#		Enemy.global_transform.origin.x += 5
#		print("lefthandArray = " + str(array1))
#		print("rightHandArray = " + str(array2))
#		print("akimboArray = " + str(array3))
#		print("Target left = " + str(targetLeft))
#		print("Target right = "+ str(targetRight))
#		print("Default left = " + str(default_left))
#		print("Rest left = " + str(restLeft))
#	if Input.is_action_just_pressed("castRay"):
#		Enemy.global_transform.origin.x -= 5
		pass
