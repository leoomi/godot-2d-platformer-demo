extends PlayerState

func enter(_msg := {}) -> void:
	player.animation.play("wall_sliding")
	if player.velocity.y > player.max_wall_slide_velocity:
		player.velocity.y = player.max_fall_velocity

func physics_update(delta: float):
	player.check_grounded_state()

	var direction = Input.get_axis("ui_left", "ui_right")
	checkFallingState(direction)

	player.apply_wall_slide_gravity(delta)
	
	player.handle_horizontal_movement(direction, delta)
	player.handle_wall_jump(direction)

	player.move_and_slide()

## Could be in the Player script but this should exclusive to this state
func checkFallingState(direction: float):
	if player.is_touching_wall(direction):
		return
		
	state_machine.transition_to("Falling")
