extends Control

var current_scene: String
var MC: String
var character_present: String
var has_waited: bool
var waited_evets: Array[String]
var current_background: String
var patience: float = 1
var sound_length: float
@export var transition_time: float = 2.0

signal npc_spawn(npc_name: String)
signal npc_desapawn(npc_name: String)
signal bg_changes(bg_name: String)
signal back_to_past(time: TimeObject)

func _ready() -> void:
	if OS.is_debug_build():
		$Intro.free()
	$Game.transition_time = transition_time

func _on_ui_character_selected(username: String) -> void:
	MC = username
	$Game/Backgrounds/CurrentBackground.texture = load("res://assets/backgrounds/Purple.jpg")
	$Game.run_dialog = true
	$Game.set_process(true)

func _on_ui_debug_mode_on(scene: String) -> void:
	MC = "DEBUG"
	$Game.debug_mode = true
	var scene_name = scene.split("/")
	print(scene_name[0])
	$Game.current_dialogue = "res://story/%s.dialogue" % scene_name[0]
	if len(scene_name) == 2:
		$Game.current_scene = scene_name[1]
	$Game.run_dialog = true
	$Game.set_process(true)

## NPC interactions
func npc_appears(npc_name: String) -> void:
	character_present = npc_name
	emit_signal("npc_spawn", npc_name)
	
func npc_leaves(npc_name: String) -> void:
	character_present = ''
	emit_signal("npc_desapawn", npc_name)


## Background interactions
func move_to_location(bg_name: String) -> void:
	current_background = bg_name
	emit_signal("bg_changes", bg_name)

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


## Check if player waited or clicked
func wait_for_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	has_waited = true
	
func check_waited(scene: String) -> void:
	if has_waited:
		waited_evets.append(scene)
	has_waited = false
	
func check_if_waited(scene: String) -> bool:
	if waited_evets.find(scene) != -1:
		return true
	return false


func play_sound(sound: String) -> void:
	$Sounds.stop()
	var sound_file := load("res://assets/sounds/%s.wav" % sound)
	$Sounds.stream = sound_file
	sound_length = $Sounds.stream.get_length()
	$Sounds.play()

## Helper methods
func back_to_the_past() -> void:
	emit_signal("back_to_past", $TimeSystem.time)


func _on_ui_main_menu() -> void:
	get_tree().reload_current_scene()
