extends CanvasLayer

@export var player: Player
const base_text = """Player state: {player_state}
Player velocity: {player_velocity}
"""
var player_state = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.is_debug_build():
		queue_free()

func _process(_delta):
	update_text()

func update_text():
	$Label.text = base_text.format({
		"player_state": format_player_state(),
		"player_velocity": player.velocity
	})

func format_player_state():
	var state = player.fsm.state
	if state.name == "Falling":
		return "%s (Fast falling: %s)" % [state.name, state.fast_falling]

	return state.name
