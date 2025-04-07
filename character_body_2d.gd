extends CharacterBody2D

@onready var player = $LPCAnimatedSprite2D as LPCAnimatedSprite2D

const SPEED = 128
var target_position = null
var is_selected = false
var stepper = StepMover.new()
var time = 0

# TODO : Create a state machine for "idle", "active", "moved", "attacking", "dead"

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if stepper.is_searching():
			return
			
		var mouse_pos = event.position.round()
		print("Mouse position: ", mouse_pos)
		
		# Step 1: Move to position
		# If the character is already selected, move if the mourse if far away and is not already moving.

		if is_selected and not stepper.is_searching():
			if global_position.distance_to(mouse_pos) < 32:
				is_selected = false
				player.play("idle_south")
			else:
				target_position = mouse_pos
				stepper.start_search(global_position, target_position)
		elif not is_selected and global_position.distance_to(mouse_pos) < 32:
			is_selected = true
			player.play("combat_idle_east")


func _physics_process(delta):
	if stepper.is_searching():
		var next_target = stepper.step_toward_target(global_position)
		var direction = stepper.search_algo.get_direction(next_target - global_position)
		
		if direction.is_equal_approx(Vector2.LEFT):
			player.play("run_west")
		elif direction.is_equal_approx(Vector2.RIGHT):
			player.play("run_east")
		elif direction.is_equal_approx(Vector2.UP):
			player.play("run_north")
		else:
			player.play("run_south")
		
		# Calculate velocity to move a specific number of pixels per frame
		var pixels_per_frame = SPEED
		velocity = direction.normalized() * pixels_per_frame
		print("Velocity: ", velocity)
		move_and_slide()
	else:
		# Stop moving when close to target
		player.play("combat_idle_east")
