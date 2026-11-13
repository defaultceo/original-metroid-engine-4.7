extends CharacterBody2D #KinematicBody2D

const speed = 30
const gravity = 500
const FLOOR = Vector2(0, -1)
#var velocity = Vector2(speed, gravity)

var dead = false
var wait = false
var samus: CharacterBody2D #KinematicBody2D

@export var enemyType: String

func _ready():
	velocity = Vector2(speed, gravity)
	if not enemyType:
		print("The enemyType variable has not been set")
		get_tree().quit()
	else:
		$AnimatedSprite.play(enemyType.to_lower())
		
	match int(round(self.rotation_degrees)):
		0: velocity = Vector2(speed, gravity)
		90, -270: velocity = Vector2(-gravity, speed)
		180, -180: velocity = Vector2(-speed, -gravity)
		270, -90: velocity = Vector2(gravity, -speed)
		
	for child in get_parent().get_children():
		if child.name == "Samus":
			samus = child
		

func _physics_process(_delta):
	if not dead:
		check_collision()
		#move_and_slide(velocity, FLOOR)
		move_and_slide()
		
		if $Area2D.overlaps_body(samus):
			samus.damageHandler(enemyType.to_lower(), self.position - samus.position)
			
		for i in get_slide_collision_count(): #get_slide_count():
			if get_slide_collision(i).collider.name == "Bomb":
				print("bruh")

func handleShot(type):
	if type == "standard" or type == "missile" or type == "bomb":
		dead = true
		
		get_node("CollisionShape2D").set_deferred("disabled", true)
		$AnimatedSprite.play("death")
		
		var pickup = preload("res://src/entities/itemPickup.tscn")
		var drops = []
		
		drops.append(pickup.instantiate())
			
		#yield($AnimatedSprite, "animation_finished")
		await $AnimatedSprite.animation_finished
		
		for drop in drops:
			drop.setPickupType("energySmall")
			
			get_parent().add_child(drop)
			drop.position = $AnimatedSprite.global_position
		
		queue_free()

		

func check_collision():

	if not $DownRayCaster.is_colliding() and not wait:
		wait = true
		if self.rotation_degrees == 270:
			self.rotation_degrees = 0
		else:
			self.rotation_degrees += 90

		match int(round(self.rotation_degrees)):
			0: velocity = Vector2(speed, gravity)
			90, -270: velocity = Vector2(-gravity, speed)
			180, -180: velocity = Vector2(-speed, -gravity)
			270, -90: velocity = Vector2(gravity, -speed)
			
	elif $SideRayCaster.is_colliding() and not wait:
		if self.rotation_degrees == 0:
			self.rotation_degrees = 270
		else:
			self.rotation_degrees -= 90
		
		match int(round(self.rotation_degrees)):
			0: velocity = Vector2(speed, gravity)
			90, -270: velocity = Vector2(-gravity, speed)
			180, -180: velocity = Vector2(-speed, -gravity)
			270, -90: velocity = Vector2(gravity, -speed)
			
		
	if $DownRayCaster.is_colliding() and wait:
		wait = false

	
