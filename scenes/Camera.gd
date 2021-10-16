extends Camera

onready var Player = get_parent()

var rayOrigin
var pastCollider

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	rayOrigin = self.global_transform.origin
	var rayEnd = Player.global_transform.origin + Vector3(0, 2, 0)
	var intersection = space_state.intersect_ray(rayOrigin,rayEnd, [self, Player])
	#rotation to mouse position
	if not intersection.empty():
		var collider = intersection.collider
		if(pastCollider!=null and pastCollider!= collider):
			pastCollider.set_layer_mask_bit(4, false)
		if(Input.is_action_just_pressed("debug")):
			print(collider.get_layer_mask_bit(0))
			print(collider.get_layer_mask_bit(1))
			print(collider.get_layer_mask_bit(2))
			print(collider.get_layer_mask_bit(3))
			print(collider.get_layer_mask_bit(4))
			print(collider.get_layer_mask_bit(5))
			print(collider.get_layer_mask_bit(6))
			print(collider.get_layer_mask_bit(7))
			print(collider.get_layer_mask_bit(8))
		if(!collider.is_in_group("Player")):
			if(collider.get_layer_mask_bit(3)):
				collider.set_layer_mask_bit(4, true)
				pastCollider = collider
#		
