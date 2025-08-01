extends Node2D

var current_scene: String
var characters_present: Array[String]
var run_dialog: bool = true
@export var current_dialogue: DialogueResource

@export var transition_speed: float = 0.05

func _ready() -> void:
	if characters_present.is_empty():
		$Characters.hide()
	current_dialogue = preload("res://story/first_day.dialogue")
	set_process(false)

func _process(_delta: float) -> void:
	if characters_present.is_empty():
		$Characters.hide()
	if run_dialog:
		run_dialog = false
		await get_tree().create_timer(1).timeout
		DialogueManager.show_dialogue_balloon(current_dialogue)



func _on_main_npc_spawn(npc_name: String) -> void:
	characters_present.append(npc_name)
	$Characters.show()


func _on_main_npc_desapawn(npc_name: String) -> void:
	characters_present.erase(npc_name)
	$Characters.show()


func _on_main_bg_changes(bg_name: String) -> void:
	var background = Image.new()
	background.load("res://assets/backgrounds/%s.jpg" % bg_name)
	assert(background)
	var texture = ImageTexture.create_from_image(background)
	$Backgrounds/NewBackground.texture = texture
	var a = 1
	while a > 0:
		$Backgrounds/CurrentBackground.modulate = Color(1, 1, 1, a)
		a -= transition_speed
		await get_tree().create_timer(transition_speed / 10).timeout
	$Backgrounds/CurrentBackground.texture = texture
	$Backgrounds/CurrentBackground.modulate = Color(1, 1, 1, 1)
