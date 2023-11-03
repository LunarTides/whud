extends CharacterBody2D


const SPEED = 200
const MAX_DISTANCE = 100
var starting_position = Vector2()
var is_fleeing = false

  
func _physics_process(delta):
	if position.x + MAX_DISTANCE < starting_position.x or position.x - MAX_DISTANCE > starting_position.x:
		flee()
	elif position.y + MAX_DISTANCE < starting_position.y or position.y - MAX_DISTANCE > starting_position.y:
		flee()

	move_and_slide()

func start():
	starting_position = position

func flee():
	if not is_fleeing:
		velocity = Vector2(0, 0)
		$AnimatedSprite2D.play("default")
		is_fleeing = true
		$Flee.play()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
