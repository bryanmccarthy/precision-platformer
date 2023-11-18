extends "state.gd"

@export var climb_speed = 50.0
@export var slide_friction = 0.7

func update(delta):
	slide_movement(delta)
	Player._animated_sprite.play("idle")
	
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	
	if Player.jump_input_actuation:
		return STATES.JUMP
	
	if Player.is_on_floor():
		return STATES.IDLE
	
	return null
	
func slide_movement(delta):
	if Player.climb_input:
		if Player.movement_input.y < 0:
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = climb_speed
		else:
			Player.velocity.y = 0
	else:
		player_movement()
		Player.gravity(delta)
		
		Player.velocity.y *= slide_friction

func enter_state():
	pass
	
func exit_state():
	pass
