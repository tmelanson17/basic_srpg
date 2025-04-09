class_name StateMachine

enum State {
	IDLE,
	SELECTED,
	MOVING,
	ATTACK
}

# POD structure for state input
class StateInput:
	var is_selected: bool = false
	var is_moving: bool = false
	var is_attacking: bool = false


var current_state: State = State.IDLE

func update(input: StateInput) -> void:
	match current_state:
		State.IDLE:
			if input.is_selected:
				current_state = State.SELECTED
		State.SELECTED:
			if input.is_moving:
				current_state = State.MOVING
			elif input.is_attacking:
				current_state = State.ATTACK
			else: # Ensure this is properly aligned and syntactically correct
				current_state = State.IDLE
		State.MOVING:
			if not input.is_moving:
				current_state = State.IDLE
		State.ATTACK:
			if not input.is_attacking:
				current_state = State.IDLE
