extends CharacterBody2D

const SLOWED_SPEED = 15.0
const WALKING_SPEED = 30.0

@export var tilemap: TileMap
@export var done_tilemap: TileMap
@export var gift_scene: PackedScene

var speed = WALKING_SPEED
var on_water = false
var water_cycle = 0
var frames = 0


func _physics_process(delta):
	var is_moving_horizontal = velocity.x != 0
	var is_moving_verical = velocity.y != 0
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	# Get the input direction and handle the movement/deceleration.
	var horizontal = Input.get_axis("move_left", "move_right")
	
	if horizontal:
		velocity.x = horizontal * speed
		
		$AnimatedSprite2D.flip_h = horizontal < 0
		if not is_moving_verical:
			$AnimatedSprite2D.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	var vertical = Input.get_axis("move_up", "move_down")
	if vertical:
		velocity.y = vertical * speed
		
		if vertical < 0:
			$AnimatedSprite2D.play("up")
		else:
			$AnimatedSprite2D.play("down")
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	if not is_moving_horizontal and not is_moving_verical:
		$AnimatedSprite2D.play("default")

		$AnimatedSprite2D.stop()
		
		$Walk.stop()
	elif not $Walk.playing and not on_water:
		$Walk.play()

	if frames % 60 == 0 and on_water and (is_moving_horizontal or is_moving_verical):
		$Walk.stop()
		
		if water_cycle & 1 == 0:
			$WaterWalk.play()
		else:
			$WaterWalkAlt.play()
		water_cycle += 1


	frames += 1
	move_and_slide()

func shoot():
	var x_velocity = 0
	var y_velocity = velocity.normalized().y
	
	if velocity.y == 0:
		x_velocity = 1 if not $AnimatedSprite2D.flip_h else -1
	
	var gift: CharacterBody2D = gift_scene.instantiate()
	gift.position = position
	gift.velocity = velocity + Vector2(gift.SPEED * x_velocity, gift.SPEED * y_velocity)
	gift.done_tilemap = done_tilemap
	gift.start()
	
	get_parent().add_child(gift)
	$Shoot.play()

func _on_area_2d_body_entered(body):
	if body == tilemap:
		on_water = false
		speed = WALKING_SPEED


func _on_area_2d_body_exited(body):
	if body == tilemap:
		on_water = true
		speed = SLOWED_SPEED
