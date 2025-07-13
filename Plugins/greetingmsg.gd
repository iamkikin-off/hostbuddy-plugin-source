# -----------------------------------------------------------------------
extends Node
# -----------------------------------------------------------------------
onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

const CONFIG_GREETINGMSG_PATH = "user://greetingmsg_config.json"

# Socks API
var Players
var Chat

var config_greeting_msg
# -----------------------------------------------------------------------
func make_example_config(file, type):
	match type:
		"GREETING_MSG":
			var default_data = {
				"greeting_msg": ""
			}
			var err = file.open(CONFIG_GREETINGMSG_PATH, File.WRITE)
			if err != OK:
				return false
			file.store_string(JSON.print(default_data, "\t"))
			file.close()
# -----------------------------------------------------------------------
func load_config():
	# Reading the config & setting variables.
	var file = File.new()
	if not file.file_exists(CONFIG_GREETINGMSG_PATH):
		make_example_config(file, "GREETING_MSG")

	var error = file.open(CONFIG_GREETINGMSG_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse(content)
	if data.error != OK:
		return false
	var json_data = data.result
	
	config_greeting_msg = json_data.get("greeting_msg", "")

	return true
# -----------------------------------------------------------------------
func _ready():
	Players = get_node_or_null("/root/ToesSocks/Players")
	Chat = get_node_or_null("/root/ToesSocks/Chat")
	Players.connect("player_added", self, "_player_added")
# -----------------------------------------------------------------------
func _player_added(player):
	config_greeting_msg = config_greeting_msg.replace("$PLAYER", Players.get_username(player))
	Chat.send_raw(config_greeting_msg, "grey", false)
# -----------------------------------------------------------------------
