extends Node

# Signals that can be emitted through the bus
signal player_selection_state_changed(state)
signal active_player_changed(player)
signal selected_character_id_changed(position)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Methods to emit signals

# Emit when player selection state changes
func emit_player_selection_state(state):
    emit_signal("player_selection_state_changed", state)

# Emit when active player changes
func emit_active_player(player):
    emit_signal("active_player_changed", player)

# Emit when selected character position changes
func emit_selected_character_id(id):
    emit_signal("selected_character_id_changed", id)
