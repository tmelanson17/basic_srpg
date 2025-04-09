extends Node2D


var offset: Vector2 = Vector2(32, 32) # Offset for the grid
var cell_size: Vector2 = Vector2(64, 64) # Default cell size

# Scales down input coordinates and returns snapped coordinates
func snap_to_grid(position: Vector2) -> Vector2:
	# Scale down and snap to the nearest grid point
	return Vector2(
		floor(position.x / cell_size.x),
		floor(position.y / cell_size.y)
	)

func grid_to_real(grid_pos: Vector2) -> Vector2:
	# Convert grid coordinates to real-world coordinates
	return Vector2(
		grid_pos.x * cell_size.x + offset.x,
		grid_pos.y * cell_size.y + offset.y
	)
