extends PlayerState

func enter(_msg := {}) -> void:
	player.animation.play("idle")

func physics_update(delta: float):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		state_machine.transition_to("Running")
		
	if not player.is_on_floor():
		state_machine.transition_to("Falling")

	player.apply_gravity(delta)
	player.handle_jump()

	player.handle_horizontal_movement(direction, delta)

	player.move_and_slide()
