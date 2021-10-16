class distance_sort extends Node:
	static func distance_sort(a,b):
		if a.global_transform.origin.distance_to(Player.global_transform.origin) < b.global_transform.origin.distance_to(Player.global_transform.origin):
			return true
		return false
