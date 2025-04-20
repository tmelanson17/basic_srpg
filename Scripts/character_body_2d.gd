extends CharacterBody2D

@onready var player = $LPCAnimatedSprite2D as LPCAnimatedSprite2D

const SPEED = 128
var target_position = null
var is_selected = false

# Import the required classes
var StepMover = preload("res://Scripts/step_mover.gd")
var PlayerStateMachine = preload("res://Scripts/player_state_machine.gd")

var stepper = StepMover.new()
var prev_position = Vector2.ZERO
var time = 0

# Add in the state machine
var state_machine = PlayerStateMachine.new()

# TODO: How to do the state input correctly?

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position.round()
		var state_input = PlayerStateMachine.StateInput.new()

		if state_machine.current_state == PlayerStateMachine.State.MOVING:
			# If the player is moving, stop moving
			stepper.stop_search()
			state_input.is_moving = false
			state_machine.update(state_input)
			# TODO: Update the player animation based on the state machine transition.
			player.play("idle_south")
		# If the player is IDLE, clicking on the player goes to SELECTED
		elif state_machine.current_state == PlayerStateMachine.State.IDLE and global_position.distance_to(mouse_pos) < 32:
			player.play("combat_idle_east")
			state_input.is_selected = true
			state_machine.update(state_input)
			SignalBus.emit_player_selection_state(state_machine.current_state)
			SignalBus.emit_selected_character_id(get_instance_id())
		# If the player is in SELECTED and clicked on again, clicking on the player goes to IDLE.
		elif state_machine.current_state == PlayerStateMachine.State.SELECTED and global_position.distance_to(mouse_pos) < 32:
			player.play("idle_south")
			state_input.is_selected = false
			state_machine.update(state_input)
			SignalBus.emit_player_selection_state(state_machine.current_state)
			SignalBus.emit_selected_character_id(KEY_NONE)
		# If the player is in SELECTED and clicked on a new position, clicking on the player goes to MOVING.
		elif state_machine.current_state == PlayerStateMachine.State.SELECTED and global_position.distance_to(mouse_pos) > 32:
			target_position = mouse_pos
			stepper.start_search(global_position, target_position)
			prev_position = global_position
			state_input.is_moving = true
			state_machine.update(state_input)
			SignalBus.emit_player_selection_state(state_machine.current_state)
			SignalBus.emit_selected_character_id(get_instance_id())


func _physics_process(delta):
	if state_machine.current_state == PlayerStateMachine.State.MOVING:
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
		# print("Velocity: ", velocity)
		move_and_slide()
		if not stepper.is_searching():
			# Stop moving when close to target
			var state_input = PlayerStateMachine.StateInput.new()
			state_input.is_moving = false
			state_machine.update(state_input)
			player.play("idle_south")
			return
