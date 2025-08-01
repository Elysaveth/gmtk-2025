extends Node2D

var current_scene: String
var character_name: String
var character_present: String
var has_waited: bool
var waited_evets: Array[String]

signal npc_spawn(npc_name: String)
signal npc_desapawn(npc_name: String)

func _on_ui_character_selected(username: String) -> void:
	character_name = username
	$Game.set_process(true)

func npc_appears(npc_name: String) -> void:
	character_present = npc_name
	emit_signal("npc_spawn", npc_name)
	
func npc_leaves(npc_name: String) -> void:
	character_present = ''
	emit_signal("npc_desapawn", npc_name)

func wait_for_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	print("Time pased")
	has_waited = true
	
func check_waited(scene: String) -> void:
	print("Checking if waited")
	if has_waited:
		waited_evets.append(scene)
	has_waited = false
	
func check_if_waited(scene: String) -> bool:
	if waited_evets.find(scene) != -1:
		return true
	return false
