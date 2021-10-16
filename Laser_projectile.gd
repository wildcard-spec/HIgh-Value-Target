extends RigidBody

var shoot = false

const damage = 1
const speed = 5


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(shoot):
		apply_impulse(transform.basis.z,-transform.basis.z * speed)

func _on_Area_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.health -= 1
		queue_free()
	else:
		queue_free()
