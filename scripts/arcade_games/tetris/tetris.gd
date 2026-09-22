extends TileMapLayer

#tetris tiles "tetrominoes"

@onready var bg_tile_map: TileMapLayer = $"../BGTileMapDetection"

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



const COLS : int = 11
const ROWS : int = 16

const DIRECTIONS := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
const GAME_OFFSET : Vector2i = Vector2i(12,0)
const START_POS : Vector2i =  GAME_OFFSET - Vector2i(8,-1)
var current_pos : Vector2i
var steps : Array
const STEPS_REQUIRED : int = 50
var speed : float
const ACCELERATION : float = 0.25

var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

var tile_id : int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

var broken_layer : int = 0
var score : int = 0
var reward : int = 10
var game_running : bool

func _ready() -> void:
	new_game()


func new_game():
	
	game_running = true
	speed = 1
	steps = [0, 0, 0] #0 -> Left; #1 -> Right; #2 -> Down
	
	piece_type = pick_piece()
	piece_atlas = Vector2i(shapes_full.find(piece_type), 0)
	next_piece_type = pick_piece()
	next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
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
	
	if check_game_over():
		get_tree().change_scene_to_file("res://scenes/arcade_games/tetris/tetris_end_screen.tscn")
		return
	draw_piece(active_piece, current_pos, piece_atlas)
	
	draw_piece(next_piece_type[0], Vector2i(15,3), next_piece_atlas)


func clear_piece():
	for k in active_piece:
		erase_cell(current_pos + k + GAME_OFFSET)


func _process(_delta: float) -> void:
	if game_running:
		if Input.is_action_pressed("left"):
			steps[0] += 5
		elif Input.is_action_pressed("right"):
			steps[1] += 5
		elif Input.is_action_pressed("down"):
			steps[2] += 5
		elif Input.is_action_just_pressed("rotate"):
			rotate_piece()
		
		if Global.tetris_score < score:
			Global.tetris_score = score
		
		update_label()
		
		steps[2] += speed
		
		for k in range(steps.size()):
			if steps[k] > STEPS_REQUIRED:
				move_piece(DIRECTIONS[k])
				steps[k] = 0


func draw_piece(piece, pos, atlas):
	for k in piece:
		set_cell(pos + k + GAME_OFFSET, tile_id, atlas, 0)


func move_piece(dir):
	if can_move(dir + GAME_OFFSET):
		clear_piece()
		current_pos += dir
		draw_piece(active_piece, current_pos, piece_atlas)
	else:
		if dir == Vector2i.DOWN:
			land_piece()
			check_rows()
			piece_type = next_piece_type
			piece_atlas = next_piece_atlas
			next_piece_type = pick_piece()
			next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
			clear_panel()
			create_piece()



func is_free(pos):
	return bg_tile_map.get_cell_source_id(pos) == -1


func can_move(dir):
	var cm : bool = true
	for k in active_piece:
		if not is_free(k + current_pos + dir):
			cm = false
	return cm


func rotate_piece():
	if can_rotate():
		clear_piece()
		rotation_index = (rotation_index + 1) % 4
		active_piece = piece_type[rotation_index]
		draw_piece(active_piece, current_pos, piece_atlas)


func can_rotate() -> bool:
	var cr : bool = true
	var temp_rotation_index = (rotation_index + 1) % 4
	
	for k in piece_type[temp_rotation_index]:
		if not is_free(k + current_pos + GAME_OFFSET):
			cr = false
			
	return cr


func land_piece():
	for k in active_piece:
		erase_cell(current_pos + k + GAME_OFFSET)
		bg_tile_map.set_cell(current_pos + k + GAME_OFFSET, tile_id, piece_atlas, 0)


func  clear_panel():
	for m in range(26, 31):
		for n in range(3, 6):
			erase_cell(Vector2i(m, n))


func check_rows():
	var row: int = ROWS
	while row > 0:
		var count = 0
		for k in range(COLS):
			if not is_free(Vector2i(k + 1, row) + GAME_OFFSET):
				count += 1
		
		if count == COLS:
			shift_rows(row)
			score += reward
			broken_layer += 1
			speed += ACCELERATION
		else:
			row -= 1


func shift_rows(row):
	for m in range(row, 1, -1):
		for n in range(COLS):
			var above_pos := Vector2i(n + 1, m - 1) + GAME_OFFSET
			var current_target_pos := Vector2i(n + 1, m) + GAME_OFFSET
			
			var atlas := bg_tile_map.get_cell_atlas_coords(above_pos)
			
			if atlas == Vector2i(-1, -1):
				bg_tile_map.erase_cell(current_target_pos)
			else:
				bg_tile_map.set_cell(current_target_pos, tile_id, atlas, 0)
				
	for n in range(COLS):
		bg_tile_map.erase_cell(Vector2i(n + 1, 1) + GAME_OFFSET)


func check_game_over() -> bool:
	for k in active_piece:
		if not is_free(k + current_pos + GAME_OFFSET):
			game_running = false
			return true
			
	return false

func update_label():
	$"../Control/ScoreMargin/ScoreLabel".text = "Score:
	" + str(score)
	
	$"../Control/HighScoreMargin/HighScoreLabel".text = "High
Score:
" + str(Global.tetris_score)
	
	$"../Control/TileBrokenMargin/TileBrokenLabel".text = "Broken:
	" + str(broken_layer)
