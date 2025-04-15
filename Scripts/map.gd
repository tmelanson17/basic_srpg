extends Node2D

var highlighted_tile = Vector2i.ZERO
var previous_highlighted_tile = Vector2i.ZERO
var tile_layer
var tile_select_material: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_layer = $TileMapLayer
	tile_select_material = load("res://highlight_material.material")

func _unhandled_input(event):
	if event is InputEventMouse:
		# Convert screen position to tile coordinates
		highlighted_tile = tile_layer.local_to_map(tile_layer.to_local(event.position))
		tile_select_material.set_shader_parameter("globalMousePos", event.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	## Only update tiles if the highlighted tile has changed
	#if highlighted_tile != previous_highlighted_tile:
		## Clear previous highlight
		#if previous_highlighted_tile != Vector2i.ZERO:
			#tile_layer.erase_cell(previous_highlighted_tile)
			#
		## Add highlight to current tile
		#tile_layer.set_cell(highlighted_tile) # Adjust the tile ID (0) as needed
		#
		#previous_highlighted_tile = highlighted_tile
