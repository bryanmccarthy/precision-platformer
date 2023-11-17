extends CharacterBody2D


var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player input
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false

# Player movement
const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var last_direction = Vector2.RIGHT

# Mechanics
var can_dash = true

# States
var current_state = null
var prev_state = null

# Nodes
@onready var STATES = $STATES
@onready var Raycasts = $Raycasts

func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

func _physics_process(delta):
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func change_state(input_state):
	if input_state:
		prev_state = current_state
		current_state = input_state
		prev_state.exit_state()
		current_state.enter_state()

func player_input():
	movement_input = Vector2.ZERO
	
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
		last_direction = Vector2.LEFT
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
		last_direction = Vector2.RIGHT
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
	
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else:
		jump_input = false
	
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else:
		jump_input_actuation = false
	
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else:
		climb_input = false

	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else:
		dash_input = false

func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	
	return null
