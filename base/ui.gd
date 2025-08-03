extends Control


signal character_selected(username: String)

var character_name: String


func _on_play_pressed() -> void:
	$Menus/BaseMenu/Main/Buttons.hide()
	$Menus/BaseMenu/Main/Username.show()

func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.


func _on_confirm_pressed() -> void:
	if not $Menus/BaseMenu/Main/Username/Username.text:
		$Menus/BaseMenu/Main/Username/EmptyWarning.show()
	else:
		character_name = $Menus/BaseMenu/Main/Username/Username.text
		emit_signal("character_selected", character_name)
		$Menus/BaseMenu/Main.hide()
		$Menus/BaseMenu/InGame.show()
		$Menus/BaseMenu/Main/Username.hide()
		$Menus/BaseMenu/Main/Username/LoadWarning.hide()
		$Menus/BaseMenu/Main/Username/EmptyWarning.hide()
		$Menus/BaseMenu/Main/Buttons.show()


func _on_pause_pressed() -> void:
	$Menus/BaseMenu/InGame.hide()
	$Menus/BaseMenu/Pause.show()


func _on_resume_pressed() -> void:
	$Menus/BaseMenu/Pause.hide()
	$Menus/BaseMenu/InGame.show()


func _on_main_menu_pressed() -> void:
	$Menus/BaseMenu/Pause.hide()
	$Menus/BaseMenu/Main.show()


func _on_username_text_submitted(_new_text: String) -> void:
	_on_confirm_pressed()


func _on_main_back_to_past(time: TimeObject) -> void:
	var time_string: String
	if time.days != 0:
		time_string += "%s Days, " % time.days
	if time.hours != 0 or time.days != 0:
		time_string += "%s Hours, " % time.hours
	if time.minutes != 0 or time.hours != 0 or time.days != 0:
		time_string += "%s Minutes, " % time.minutes
	time_string += "%s Seconds, " % time.seconds
	$GameEvents/BackToThePast/TimePlayed.text = """
	[b][i]You have played:[/i][/b][i][/i]
	[fade start=-1 length=%s][b]%s[/b][/fade]""" % [len(time_string) + 4, time_string]
