extends RigidBody

var shoot = false

const damage = 2
const speed = 5

var target

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	set_as_toplevel(true)

func passParameters(a):
	target = a

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(shoot):
		apply_impulse(transform.basis.z,-transform.basis.z * speed)

func _on_Area_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.health -= damage
		queue_free()
	else:
		queue_free()


func _on_HomeTimer_timeout():
	home()
	
func home():
	self.look_at(target+Vector3(0,1.5,0),Vector3.UP)
	apply_impulse(transform.basis.z,-transform.basis.z * speed)
