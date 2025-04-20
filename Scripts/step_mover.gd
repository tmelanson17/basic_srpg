var Search = preload("res://Scripts/search.gd")
var Grid = preload("res://Scripts/grid.gd")

var speed = 100
var MAX_X = 100
var MAX_Y = 100
var searching = false
var target_position = Vector2.ZERO
var current_position = Vector2.ZERO
var path = {}
var i = 0

var search_algo = Search.new()
var grid = Grid.new()

func start_search(new_start, new_target):
	current_position = grid.snap_to_grid(new_start)
	target_position = grid.snap_to_grid(new_target)
	print("Current position: ", current_position)
	print("Goal target position: ", target_position)

	var occupied = {}
	for x in range(MAX_X):
		for y in range(MAX_Y):
			occupied[Vector2(x, y)] = 0
	path = search_algo.bfs(current_position, target_position, occupied)
	searching = true

# TODO: Make all outputs go through step size increase
func step_toward_target(position):
	if not searching:
		return position
	var target_pos = grid.grid_to_real(path[i])
	if position.is_equal_approx(target_pos):
		i += 1
	if i < path.size():
		var next_position = path[i]
		return grid.grid_to_real(next_position)
	else:
		searching = false
		i = 0
		return position
		
func is_searching():
	return searching
