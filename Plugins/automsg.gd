extends Node

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

const CONFIG_AUTOMSG_PATH = "user://automsg_config.json"

# Socks API
var Players
var Chat

var time_config = 0
var messages_config = []

var time = 0

func make_example_config(file, type):
	match type:
		"AUTOMSG":
			var default_data = {
				"time": 5,
				"messages": [">:c",">:)"]
			}
			var err = file.open(CONFIG_AUTOMSG_PATH, File.WRITE)
			if err != OK:
				return false
			file.store_string(JSON.print(default_data, "\t"))
			file.close()

func load_config():
	# Reading the config & setting variables.
	var file = File.new()
	if not file.file_exists(CONFIG_AUTOMSG_PATH):
		make_example_config(file, "AUTOMSG")

	var error = file.open(CONFIG_AUTOMSG_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse(content)
	if data.error != OK:
		return false
	var json_data = data.result
	
	time_config = json_data.get("time", 0)
	messages_config = json_data.get("messages", [])

	return true

func _ready():
	Players = get_node_or_null("/root/ToesSocks/Players")
	Chat = get_node_or_null("/root/ToesSocks/Chat")
	load_config()

func _process(delta):
	if Players:
		if Players.in_game:
			time = time + delta
			if time >= time_config:
				var random_msg = messages_config
				random_msg.shuffle()
				var final_msg = random_msg[0]
				Chat.send_raw(final_msg, "gray", false)
				time = 0
