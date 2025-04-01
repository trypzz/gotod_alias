extends Control

@onready var createLobby_button = $VBoxContainer/CreateGameButton
@onready var username_input = $VBoxContainer/UserName

func _ready():
	createLobby_button.pressed.connect(_on_create_game_pressed)

func _on_create_game_pressed():
	var peer = ENetMultiplayerPeer.new()
	var server = peer.create_server(12345, 10)  # порт, макс. гравців
	if server != OK:
		print("❌ Не вдалося створити сервер!")
		return

	multiplayer.multiplayer_peer = peer
	print("✅ Сервер запущено!")
	print("Username: " + username_input.text)
	print("✅ Створено сервер з ID:", multiplayer.get_unique_id())
	Global.username = username_input.text
	get_tree().change_scene_to_file("res://Lobby.tscn")
