extends PlayerState

var fast_falling = false ## This could be a state but holy shit I've done this way too much

func enter(_msg := {}) -> void:
	player.animation.play("falling")
	fast_falling = false

func physics_update(delta: float):
	player.check_grounded_state()

	var direction = Input.get_axis("ui_left", "ui_right")
	if player.is_touching_wall(direction):
		state_machine.transition_to("WallSliding")

	if Input.is_action_just_pressed("ui_down"):
		fast_falling = true
		player.velocity.y = player.fast_fall_velocity

	if not fast_falling:
		player.apply_gravity(delta)

	player.handle_horizontal_movement(direction, delta)
	player.handle_wall_jump(direction)

	player.move_and_slide()

