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
		if(PlayerVariables.targetPracticeTargets.has(enemySelf)):
			leftCrosshair.show()
			self.show()
		if(PlayerVariables.isTargetPracticeEffectTimerActive == false || PlayerVariables.isTargetPracticeTimerActive == false):
			self.hide()
	#elif(targetRight==enemySelf and IK!=null and PlayerVariables.is_manualAim):
	#	leftCrosshair.hide()
	#	rightCrosshair.show()
	elif(IK==null):
		self.hide()
		leftCrosshair.hide()
		rightCrosshair.hide()
		
	
