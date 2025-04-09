extends Node

# Directions for grid movement: up, down, left, right
var directions = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]

func get_direction(vect: Vector2) -> Vector2:
	var angle = vect.angle()
	print(abs(angle))
	if abs(angle) < PI / 4:
		return Vector2.RIGHT
	elif abs(angle) > 3 * PI / 4:
		return Vector2.LEFT
	elif angle > 0:
		return Vector2.DOWN
	else:
		return Vector2.UP

# Perform BFS to find the shortest path
func bfs(start, target, grid):
	var queue = [start]
	var visited = {}
	var came_from = {}
	
	visited[start] = true
	
	while queue:
		var current = queue.pop_front()
		
		# If we reach the target, stop
		if current == target:
			return reconstruct_path(came_from, start, target)
		
		# Explore neighboring cells
		for direction in directions:
			var neighbor = current + direction
			
			# Check if within grid bounds and is walkable
			if grid.has(neighbor) and not visited.has(neighbor) and grid[neighbor] == 0:
				visited[neighbor] = true
				came_from[neighbor] = current
				queue.append(neighbor)
	
	return [] # Return an empty path if no path is found

# Reconstruct the path from the 'came_from' dictionary
func reconstruct_path(came_from, start, target):
	var path = []
	var current = target
	
	while current != start:
		path.append(current)
		current = came_from[current]
	
	path.append(start)
	path.reverse()
	return path
