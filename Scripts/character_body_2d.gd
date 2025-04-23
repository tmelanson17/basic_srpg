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
var inactive = false

# Add in the state machine
var state_machine = PlayerStateMachine.new()

# TODO: How to do the state input correctly?
func _ready():
	# Connect the signals to the state machine
	SignalBus.connect("selected_character_id_changed", _on_receive_selected_character_id)
	prev_position = global_position

func _unhandled_input(event):
	if inactive:
		return
	var state_input = PlayerStateMachine.StateInput.new()
	# If the escape key is pressed in the SELECTED state, go to IDLE
	if event.is_action_pressed("ui_cancel") and (
		state_machine.current_state == PlayerStateMachine.State.SELECTED or
		state_machine.current_state == PlayerStateMachine.State.MOVING):
		state_input.is_selected = false
		state_input.is_moving = false
		state_machine.update(state_input, self)
	elif event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position.round()
		if state_machine.current_state == PlayerStateMachine.State.MOVING:
			state_input.is_moving = false
			state_machine.update(state_input, self)
		# If the player is IDLE, clicking on the player goes to SELECTED
		elif state_machine.current_state == PlayerStateMachine.State.IDLE and global_position.distance_to(mouse_pos) < 32:
			state_input.is_selected = true
			state_machine.update(state_input, self)
		# If the player is in SELECTED and clicked on again, clicking on the player goes to IDLE.
		elif state_machine.current_state == PlayerStateMachine.State.SELECTED and global_position.distance_to(mouse_pos) < 32:
			state_input.is_selected = false
			state_machine.update(state_input, self)
		# If the player is in SELECTED and clicked on a new position, clicking on the player goes to MOVING.
		elif state_machine.current_state == PlayerStateMachine.State.SELECTED and global_position.distance_to(mouse_pos) > 32:
			target_position = mouse_pos
			prev_position = global_position
			state_input.is_moving = true
			state_machine.update(state_input, self)


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
			# TODO: Create special case for this.
			prev_position = global_position
			# Stop moving when close to target
			var state_input = PlayerStateMachine.StateInput.new()
			state_input.is_moving = false
			state_machine.update(state_input, self)

###
## State Transitions
###

func on_transition_to_idle():
	# Called when the state machine transitions to IDLE
	print("Transitioning to IDLE state")
	# If the player is moving, stop moving
	stepper.stop_search()
	set_global_position(prev_position)
	player.play("idle_south")
	SignalBus.emit_player_selection_state(state_machine.current_state)
	SignalBus.emit_selected_character_id(KEY_NONE)

func on_transition_to_selected():
	# Called when the state machine transitions to MOVING
	print("Transitioning to MOVING state")
	player.play("combat_idle_east")
	SignalBus.emit_player_selection_state(state_machine.current_state)
	SignalBus.emit_selected_character_id(get_instance_id())

func on_transition_to_moving():
	# Called when the state machine transitions to MOVING
	print("Transitioning to MOVING state")
	stepper.start_search(global_position, target_position)

func on_transition(state):
	# Called when the state machine transitions to a new state
	match state:
		PlayerStateMachine.State.IDLE:
			on_transition_to_idle()
		PlayerStateMachine.State.SELECTED:
			on_transition_to_selected()
		PlayerStateMachine.State.MOVING:
			on_transition_to_moving()


func _on_receive_selected_character_id(player_id):
	# If the the id is not equal to this player's id, set inactive
	if player_id != get_instance_id() and player_id != KEY_NONE:
		inactive = true
		var state_input = PlayerStateMachine.StateInput.new()
		state_input.is_moving = false
		state_input.is_selected = false
		state_machine.update(state_input, self)
