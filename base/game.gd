extends Node2D

var current_dialogue: String
var current_scene: String
var characters_present: Array[String]
var run_dialog: bool = true
var transition_time: float
var debug_mode: bool = false
@export var intro_dialogue: DialogueResource
@export var transition_speed: float = 0.02

var balloon: Node

func _ready() -> void:
	if characters_present.is_empty():
		$Characters.hide()
	intro_dialogue = preload("res://story/intro.dialogue")
	set_process(false)

func _process(_delta: float) -> void:
	if characters_present.is_empty():
		$Characters.hide()
	if run_dialog:
		run_dialog = false
		if balloon:
			balloon.free()
		await get_tree().create_timer(1).timeout
		if debug_mode:
			if current_scene.is_empty():
				balloon = DialogueManager.show_dialogue_balloon(load(current_dialogue))
			else:
				balloon = DialogueManager.show_dialogue_balloon(load(current_dialogue), current_scene)
				
		else:
			balloon = DialogueManager.show_dialogue_balloon(intro_dialogue)


func _on_main_npc_spawn(npc_name: String) -> void:
	characters_present.append(npc_name)
	var texture := load("res://assets/characters/%s.png" % npc_name)
	if texture:
		$Characters/Control/Character/CurrentSprite.texture = texture
	else:
		$Characters/Control/Character/CurrentSprite.texture = load("res://assets/characters/test-character.png")
	$Characters/Control/Character/CurrentSprite.modulate = Color(1, 1, 1, 0)
	$Characters.show()
	var a := 0.0
	while a < 1.0:
		$Characters/Control/Character/CurrentSprite.modulate = Color(1, 1, 1, a)
		a += (transition_time / 100.0)
		await get_tree().create_timer(transition_time / 200.0).timeout


func _on_main_npc_desapawn(npc_name: String) -> void:
	characters_present.erase(npc_name)
	var a := 1.0
	while a < 0.0:
		$Characters/Control/Character/CurrentSprite.modulate = Color(1, 1, 1, a)
		a += (transition_time / 100.0)
		await get_tree().create_timer(transition_time / 200.0).timeout
	$Characters.hide()


func _on_main_bg_changes(bg_name: String) -> void:
	var baloon = balloon.get_child(0)
	var a := 1.0
	while a > 0.0:
		baloon.modulate = Color(1, 1, 1, a)
		a -= (transition_time/ 50.0)
		await get_tree().create_timer(transition_time / 200.0).timeout
	await get_tree().create_timer(transition_time / 2.0).timeout
	var texture := load("res://assets/backgrounds/%s.jpg" % bg_name)
	if texture:
		$Backgrounds/NewBackground.texture = texture
	else:
		$Backgrounds/NewBackground.texture = load("res://assets/backgrounds/Purple.jpg")
		
	a = 1.0
	while a > 0.0:
		$Backgrounds/CurrentBackground.modulate = Color(1, 1, 1, a)
		a -= (transition_time / 100.0)
		await get_tree().create_timer(transition_time / 100.0).timeout
	if texture:
		$Backgrounds/CurrentBackground.texture = texture
	else:
		$Backgrounds/CurrentBackground.texture = load("res://assets/backgrounds/Purple.jpg")
	$Backgrounds/CurrentBackground.modulate = Color(1, 1, 1, 1)
	await get_tree().create_timer(transition_time / 2.0).timeout
	a = 0.0
	while a < 1.0:
		baloon.modulate = Color(1, 1, 1, a)
		a += (transition_time/ 50.0)
		await get_tree().create_timer(transition_time / 200.0).timeout


func _on_main_back_to_past(time: TimeObject) -> void:
	balloon = DialogueManager.show_dialogue_balloon(intro_dialogue)
