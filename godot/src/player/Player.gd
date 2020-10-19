extends Area2D

signal hit

# These only need to be accessed in this script, so we can make them private.
# Private variables in GDScript have their name starting with an underscore.
export var _speed = 400 # How fast the player will move (pixels/sec).
var _screen_size # Size of the game window.
var target = Vector2()
var velocity = Vector2()

func _ready():
	_screen_size = get_viewport_rect().size
	hide()

# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
		# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * _speed
		
	else:
		velocity = Vector2()
	
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1

	if velocity.length() > 0:		
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
#	position.x = clamp(position.x, 0, _screen_size.x)
#	position.y = clamp(position.y, 0, _screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func start(pos):
	position = pos
	target = pos
	show()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
