extends Node2D

var current_scene: String
var character_present: String = ''
var run_dialog: bool = true
@export var current_dialogue: DialogueResource

func _ready() -> void:
	current_dialogue = preload("res://story/first_day.dialogue")
	set_process(false)

func _process(_delta: float) -> void:
	if run_dialog:
		run_dialog = false
		await get_tree().create_timer(1).timeout
		DialogueManager.show_dialogue_balloon(current_dialogue)
