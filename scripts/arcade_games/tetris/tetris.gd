extends TileMapLayer

#tetris tiles "tetrominoes"

var i_0 := [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1)]
var i_90 := [Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3)]
var i_180 := [Vector2i(0,2), Vector2i(1,2), Vector2i(2,2), Vector2i(3,2)]
var i_270 := [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)]
var i := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
var t_90 := [Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)]
var t_180 := [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)]
var t_270 := [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var o_90 := [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var o_180 := [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var o_270 := [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var o := [o_0, o_90, o_180, o_270]

var z_0 := [Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(2,1)]
var z_90 := [Vector2i(2,0), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)]
var z_180 := [Vector2i(0,1), Vector2i(1,1), Vector2i(1,2), Vector2i(2,1)]
var z_270 := [Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(0,2)]
var z := [z_0, z_90, z_180, z_270]

var s_0 := [Vector2i(1,0), Vector2i(2,0), Vector2i(0,1), Vector2i(1,1)]
var s_90 := [Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)]
var s_180 := [Vector2i(1,1), Vector2i(2,1), Vector2i(0,2), Vector2i(1,2)]
var s_270 := [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)]
var s := [s_0, s_90, s_180, s_270]

var l_0 := [Vector2i(2,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
var l_90 := [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(2,2)]
var l_180 := [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(0,2)]
var l_270 := [Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)]
var l := [l_0, l_90, l_180, l_270]

var j_0 := [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
var j_90 := [Vector2i(1,0), Vector2i(2,0), Vector2i(1,1), Vector2i(1,2)]
var j_180 := [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)]
var j_270 := [Vector2i(1,0), Vector2i(1,1), Vector2i(0,2), Vector2i(1,2)]
var j := [j_0, j_90, j_180, j_270]

var shapes := [i, t, o, z, s, l, j]
var shapes_full := shapes.duplicate()


const COLS : int = 13
const ROWS : int = 16

const DIRECTIONS := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
const GAME_OFFSET : Vector2i = Vector2i(12,0)
const START_POS : Vector2i =  GAME_OFFSET - Vector2i(8,-1)
var current_pos : Vector2i
var steps : Array
const STEPS_REQUIRED : int = 50
var speed : int

var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

var tile_id : int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

var board_layer : int = 0
var active_layer : int = 1


func _ready() -> void:
	new_game()


func new_game():
	
	speed = 1
	steps = [0, 0, 0] #0 -> Left; #1 -> Right; #2 -> Down
	
	piece_type = pick_piece()
	piece_atlas = Vector2i(shapes_full.find(piece_type), 0)
	create_piece()


func pick_piece():
	var piece
	if not shapes.is_empty():
		shapes.shuffle()
		piece = shapes.pop_front()
	else:
		shapes = shapes_full.duplicate()
		piece = shapes.pop_front()
	return piece


func create_piece():
	steps = [0, 0, 0]
	current_pos = START_POS
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, current_pos, piece_atlas)


func clear_piece():
	for k in active_piece:
		erase_cell(current_pos + k + GAME_OFFSET)


func _process(_delta: float) -> void:
	if Input.is_action_pressed("left"):
		steps[0] += 5
	elif Input.is_action_pressed("right"):
		steps[1] += 5
	elif Input.is_action_pressed("down"):
		steps[2] += 5
	
	
	
	
	steps[2] += speed
	
	for k in range(steps.size()):
		if steps[k] > STEPS_REQUIRED:
			move_piece(DIRECTIONS[k])
			steps[k] = 0


func draw_piece(piece, pos, atlas):
	for k in piece:
		set_cell(pos + k + GAME_OFFSET, tile_id, atlas, 0)


func move_piece(dir):
	if can_move(dir):
		clear_piece()
		current_pos += dir
		draw_piece(active_piece, current_pos, piece_atlas)


func is_free(pos):
	var source_id := get_cell_source_id(pos)
	if source_id == -1:
		return
	var atlas_coords := get_cell_atlas_coords(pos)
	if atlas_coords == Vector2i(7,0):
		return -1


func can_move(dir):
	var cm : bool = true
	for k in active_piece:
		if not is_free(k + current_pos + dir):
			cm = false
	return cm
