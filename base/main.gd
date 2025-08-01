extends Node2D

var current_scene: String
var character_name: String

func _on_ui_character_selected(username: String) -> void:
	character_name = username
	$Game.set_process(true)
