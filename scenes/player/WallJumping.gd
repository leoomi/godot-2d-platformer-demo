extends PlayerState

func enter(msg := {}) -> void:
	player.animation.play("jumping")
	player.velocity.y = player.wall_jump_velocity.y
	player.velocity.x = msg.direction * player.wall_jump_velocity.x
	player.flip(msg.direction)

	await get_tree().create_timer(8 * 0.01667).timeout
	if not player.fsm.state.name == self.name:
		return

	state_machine.transition_to("Jumping", {"no_jump": true})

func physics_update(delta: float):
	if player.velocity.y >= 0 || player.is_on_ceiling():
		state_machine.transition_to("Falling")

	player.apply_gravity(delta)

	player.move_and_slide()
