extends Control

var players_list = {}


@onready var players_status = $VBoxContainer/PlayersStatusLabel
@onready var start_button = $StartGame

func _ready():
	var id = multiplayer.get_unique_id()
	
	# Якщо хост (ID==1), встановлюємо свою назву або "Host"
	if id == 1:
		start_button.disabled = false
		start_button.text = "Start Game"
		start_button.pressed.connect(_on_start_game_pressed)
	else:
		start_button.disabled = true
		start_button.text = "Очікуємо старту від хоста"

	rpc_id(1, "register_player", id, Global.username)
	update_player_list()


# RPC-функція, яку викликають клієнти для реєстрації свого нікнейма
@rpc("any_peer")
func register_player(peer_id, nickname):
	players_list.set(peer_id, nickname)
	print("Гравець зареєстрований: ", peer_id, nickname)
	update_player_list()

# Оновлення інтерфейсу (список гравців)
func update_player_list():
	var list_text = "Гравці:\n"
	for id in players_list.keys():
		list_text += "%s\n" % [players_list[id]]
	players_status.text = list_text

# RPC-функція для старту гри
@rpc("any_peer")
func _start_game():
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_start_game_pressed():
	print("Хост починає гру")
	_start_game.rpc()
