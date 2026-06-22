extends Control

const GAME_SCENE = preload("res://main/main.tscn")

func _on_host_button_pressed():
	NetworkService.start_server()
	start_game()

func _on_join_button_pressed():
	$Join.visible = true

func _on_join_game_button_pressed():
	NetworkService.join_server($Join/CenterContainer/VBoxContainer/IPLine.text)
	start_game()

func start_game():
	get_tree().change_scene_to_packed(GAME_SCENE)
