extends Control


signal character_selected(username: String)

var character_name: String


func _on_play_pressed() -> void:
	$Menus/BaseMenu/Main/Buttons.visible = false
	$Menus/BaseMenu/Main/Username.visible = true

func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.


func _on_confirm_pressed() -> void:
	if not $Menus/BaseMenu/Main/Username/Username.text:
		$Menus/BaseMenu/Main/Username/EmptyWarning.visible = true
	else:
		character_name = $Menus/BaseMenu/Main/Username/Username.text
		emit_signal("character_selected", character_name)
		$Menus/BaseMenu/Main.visible = false
		$Menus/BaseMenu/InGame.visible = true
		$Menus/BaseMenu/Main/Username.visible = false
		$Menus/BaseMenu/Main/Username/LoadWarning.visible = false
		$Menus/BaseMenu/Main/Username/EmptyWarning.visible = false
		$Menus/BaseMenu/Main/Buttons.visible = true


func _on_pause_pressed() -> void:
	$Menus/BaseMenu/InGame.visible = false
	$Menus/BaseMenu/Pause.visible = true


func _on_resume_pressed() -> void:
	$Menus/BaseMenu/Pause.visible = false
	$Menus/BaseMenu/InGame.visible = true


func _on_main_menu_pressed() -> void:
	$Menus/BaseMenu/Pause.visible = false
	$Menus/BaseMenu/Main.visible = true


func _on_username_text_submitted(new_text: String) -> void:
	_on_confirm_pressed()
