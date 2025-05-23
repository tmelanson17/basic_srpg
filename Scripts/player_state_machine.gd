class_name PlayerStateMachine

enum State {
	IDLE = 0,
	SELECTED = 1,
	MOVING = 2,
	ATTACK = 3,
}

# POD structure for state input
class StateInput:
	var is_selected: bool = false
	var is_moving: bool = false
	var is_attacking: bool = false


var current_state: State = State.IDLE

func update(input: StateInput, cls: CharacterBody2D) -> void:
	var prev_state = current_state
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
	if prev_state != current_state:
		cls.on_transition(current_state)
