#extends Node2D
#
#var current_strength = 0
#
#func _ready():
	#pass
	#
#func moveCamera(vec:Vector2):
	#get_parent().get_node("Camera2D").offset = Vector2(rand_range(-vec.x, vec.x), rand_range(-vec.y, vec.y))
#
#func shakeScreen(length, power):
	#if power >= current_strength:
		#print("yes")
		#current_strength = power
		#$Tween.interpolate_method(self, "moveCamera", Vector2(power, power), Vector2(0, 0), length, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		#$Tween.start()
		##yield($Tween, "tween_completed")
		#await $Tween.tween_completed
	#
		#if not $Tween.is_processing():
			#current_strength = 0


extends Node2D

var current_strength = 0

func _ready():
	pass
	
func moveCamera(vec: Vector2):
	get_parent().get_node("Camera2D").offset = Vector2(randf_range(-vec.x, vec.x), randf_range(-vec.y, vec.y)) #rand_range

func shakeScreen(length, power):
	if power >= current_strength:
		print("yes")
		current_strength = power
		var tween = create_tween()
		tween.tween_method(moveCamera, Vector2(power, power), Vector2(0, 0), length).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		
		if not tween.is_running():
			current_strength = 0   
