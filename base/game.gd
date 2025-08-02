extends Node2D

var current_scene: String
var characters_present: Array[String]
var run_dialog: bool = true
var transition_time: float
@export var current_dialogue: DialogueResource
@export var transition_speed: float = 0.02

var balloon: Node

func _ready() -> void:
	if characters_present.is_empty():
		$Characters.hide()
	current_dialogue = preload("res://story/intro.dialogue")
	set_process(false)

func _process(_delta: float) -> void:
	if characters_present.is_empty():
		$Characters.hide()
	if run_dialog:
		run_dialog = false
		await get_tree().create_timer(1).timeout
		balloon = DialogueManager.show_dialogue_balloon(current_dialogue)


func _on_main_npc_spawn(npc_name: String) -> void:
	characters_present.append(npc_name)
	$Characters.show()


func _on_main_npc_desapawn(npc_name: String) -> void:
	characters_present.erase(npc_name)
	$Characters.show()


func _on_main_bg_changes(bg_name: String) -> void:
	var baloon = balloon.get_child(0)
	var a := 1.0
	while a > 0:
		baloon.modulate = Color(1, 1, 1, a)
		a -= (transition_time/ 50)
		await get_tree().create_timer(transition_time / 500).timeout
	await get_tree().create_timer(transition_time / 2).timeout
	$Backgrounds/NewBackground.texture = load("res://assets/backgrounds/%s.jpg" % bg_name)
	a = 1
	while a > 0:
		$Backgrounds/CurrentBackground.modulate = Color(1, 1, 1, a)
		a -= (transition_time / 100.0)
		await get_tree().create_timer(transition_time / 100.0).timeout
	$Backgrounds/CurrentBackground.texture = load("res://assets/backgrounds/%s.jpg" % bg_name)
	$Backgrounds/CurrentBackground.modulate = Color(1, 1, 1, 1)
	await get_tree().create_timer(transition_time / 2).timeout
	a = 0
	while a < 1:
		baloon.modulate = Color(1, 1, 1, a)
		a += (transition_time/ 50)
		await get_tree().create_timer(transition_time / 50).timeout
