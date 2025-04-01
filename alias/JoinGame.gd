extends Control

@onready var ip_input = $VBoxContainer/IPInput
@onready var connect_button = $VBoxContainer/ConnectButton
@onready var status_label = $VBoxContainer/StatusLabel
@onready var username_input = $VBoxContainer/UserName


func _ready():
	connect_button.pressed.connect(_on_connect_pressed)
	status_label.text = ""  # Очистити статус при запуску

func _on_connect_pressed():
	var ip = ip_input.text.strip_edges()
	
	if ip.is_empty():
		status_label.text = "⚠️ Введіть IP-адресу!"
		return

	var peer = ENetMultiplayerPeer.new()
	var client = peer.create_client(ip, 12345)

	if client != OK:
		status_label.text = "❌ Помилка підключення (код: %d)".format(client)
		print("Помилка створення клієнта ENet:", client)
		return

	multiplayer.multiplayer_peer = peer
	status_label.text = "🔄 Підключення..."

	# Перевіримо, чи реально підключено після невеликої затримки
	await get_tree().create_timer(1.0).timeout

	if multiplayer.get_unique_id() == 1:
		# Це означає, що ми самі стали сервером — отже, підключення провалене
		status_label.text = "❌ Не вдалося підключитися (вірогідно, сервер не запущено)"
		multiplayer.multiplayer_peer = null
	else:
		Global.username = username_input.text
		print("✅ Підключено до сервера з ID:", multiplayer.get_unique_id())
		status_label.text = "✅ Підключено! Перехід у Lobby..."
		rpc_id(1, "register_player", multiplayer.get_unique_id(), Global.username)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Lobby.tscn")
