extends Camera


onready var Camera1 = get_node("../Camera")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("camera_switch"):
		if(self.current== true):
			Camera1.set_current(1)
		else:
			 self.set_current(1)
