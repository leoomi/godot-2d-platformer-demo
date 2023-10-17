class_name Player
extends CharacterBody2D

@export var max_speed = 250.0
@export var max_fall_velocity = 250.0
@export var max_wall_slide_velocity = 100.0
@export var fast_fall_velocity = 400.0
@export var acceleration = 750.0
@export var short_jump_velocity = -300
@export var jump_velocity = -400.0
@export var wall_jump_velocity = Vector2(150, -450)
@onready var fsm: StateMachine = $StateMachine
@onready var animation: AnimationPlayer = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func flip(direction):
	## this is confusing af: https://ask.godotengine.org/92282/why-my-character-scale-keep-changing?show=146969#a146969
	transform.x.x = direction

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, delta * gravity)

func apply_wall_slide_gravity(delta: float):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_wall_slide_velocity, delta * gravity)

func check_grounded_state():
	if not is_on_floor():
		return

	var state = "Idle"
	
	if velocity.length() != 0:
		state = "Running"

	fsm.transition_to(state)

func handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if handle_drop_from_platform():
			return
		fsm.transition_to("JumpSquatting")

func handle_drop_from_platform() -> bool:
	if not Input.is_action_pressed("ui_down"):
		return false
	
	if not is_colliding_with_one_way():
		return false
	
	position.y += 1
	fsm.transition_to("Falling")
	return true

func is_colliding_with_one_way() -> bool:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		## TODO fix for tilemaps
		if collision.get_collider_shape().one_way_collision:
			return true

	return false

func handle_horizontal_movement(direction: float, delta: float):
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, delta * acceleration)
		flip(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)

func handle_wall_jump(direction: float):
	if Input.is_action_just_pressed("ui_accept") and is_touching_wall(direction):
		var wall_normal = get_wall_normal()

		fsm.transition_to("WallJumping", {
			"direction": wall_normal.x
		})

func is_touching_wall(direction) -> bool:
	if not is_on_wall_only():
		return false

	var wall_normal = get_wall_normal()
	
	var is_not_flat_wall = abs(wall_normal.x) != 1
	if is_not_flat_wall:
		return false
		
	var opposite_direction_input = not sign(direction) == -sign(wall_normal.x)
	if opposite_direction_input:
		return false

	return true
