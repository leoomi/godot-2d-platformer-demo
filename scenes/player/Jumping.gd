extends PlayerState

var first_frame = false

func enter(msg := {}) -> void:
	player.animation.play("jumping")

	if msg.has("no_jump") and msg.no_jump:
		return

	first_frame = true
	if not msg.has("long_jump") or msg.long_jump:
		player.velocity.y = player.jump_velocity
		return

	player.velocity.y = player.short_jump_velocity

func physics_update(delta: float):
	if not first_frame:
		player.check_grounded_state()

	if player.velocity.y >= 0:
		state_machine.transition_to("Falling")

	player.apply_gravity(delta)
	
	var direction = Input.get_axis("ui_left", "ui_right")

	player.handle_horizontal_movement(direction, delta)
	player.handle_wall_jump(direction)

	player.move_and_slide()

	first_frame = false
