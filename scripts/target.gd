tool
extends Spatial
class_name TargetDisplay, "res://icons/target_opt_test.svg"
onready var enemySelf = get_parent()
onready var leftCrosshair = get_node("leftCrosshair")
onready var rightCrosshair = get_node("rightCrosshair")
onready var Player = enemySelf.get_node("../Player")
onready var IK = Player.get_node("IK_Control")
onready var camera = Player.get_node("Pivot/Camera")
onready var player_vars = get_node("/root/PlayerVariables")
var targetLeft
var targetRight

func _ready():
	self.hide()

func _process(delta):
	if(IK!=null):
		targetLeft = IK.get("targetLeft")
		targetRight = IK.get("targetRight")
		leftCrosshair.show()
		
	if(IK!=null and PlayerVariables.is_manualAim):
		if(PlayerVariables.isTargetPracticeEffectTimerActive and PlayerVariables.targetPracticeTargets.has(enemySelf)):
			var leftPos = leftCrosshair.global_transform.origin.direction_to(camera.global_transform.origin)
			leftPos.y = 1.6
			leftCrosshair.global_transform.origin = enemySelf.global_transform.origin + leftPos
			leftCrosshair.show()
			self.show()
		if(PlayerVariables.isTargetPracticeEffectTimerActive == false):
			print("we get here")
			self.hide()
	#elif(targetRight==enemySelf and IK!=null and PlayerVariables.is_manualAim):
	#	leftCrosshair.hide()
	#	var rightPos = rightCrosshair.global_transform.origin.direction_to(camera.global_transform.origin)
	#	rightPos.y = 1.6
	#	rightCrosshair.global_transform.origin = enemySelf.global_transform.origin + rightPos
	#	rightCrosshair.show()
	elif(IK!=null):
		leftCrosshair.hide()
		rightCrosshair.hide()
		
	
