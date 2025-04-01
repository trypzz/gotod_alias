extends Control

@onready var host_button = $VBoxContainer/HostGame
@onready var join_button = $VBoxContainer/JoinGame
@onready var options_button = $VBoxContainer/Options
@onready var exit_button = $VBoxContainer/Exit

func _ready():
	host_button.pressed.connect(_on_host_game_pressed)
	join_button.pressed.connect(_on_join_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_host_game_pressed():
	get_tree().change_scene_to_file("res://CreateGame.tscn")

func _on_join_game_pressed():
	get_tree().change_scene_to_file("res://JoinGame.tscn")

func _on_options_pressed():
	print("Options clicked")
	# TODO: Відкрити меню налаштувань

func _on_exit_pressed():
	get_tree().quit()
