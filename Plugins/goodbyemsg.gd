# -----------------------------------------------------------------------
extends Node
# -----------------------------------------------------------------------
onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

const CONFIG_GOODBYEMSG_PATH = "user://goodbyemsg_config.json"

# Socks API
var Players
var Chat

var config_goodbye_msg
# -----------------------------------------------------------------------
func make_example_config(file, type):
	match type:
		"GOODBYE_MSG":
			var default_data = {
				"goodbye_msg": "$PLAYER, why did you leave us?"
			}
			var err = file.open(CONFIG_GOODBYEMSG_PATH, File.WRITE)
			if err != OK:
				return false
			file.store_string(JSON.print(default_data, "\t"))
			file.close()
# -----------------------------------------------------------------------
func load_config():
	# Reading the config & setting variables.
	var file = File.new()
	if not file.file_exists(CONFIG_GOODBYEMSG_PATH):
		make_example_config(file, "GOODBYE_MSG")

	var error = file.open(CONFIG_GOODBYEMSG_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse(content)
	if data.error != OK:
		return false
	var json_data = data.result
	
	config_goodbye_msg = json_data.get("goodbye_msg", "")

	return true
# -----------------------------------------------------------------------
func _ready():
	Players = get_node_or_null("/root/ToesSocks/Players")
	Chat = get_node_or_null("/root/ToesSocks/Chat")
	Players.connect("player_removed", self, "_player_removed")
	load_config()
# -----------------------------------------------------------------------
func _player_removed(player):
	config_goodbye_msg = config_goodbye_msg.replace("$PLAYER", Players.get_username(player))
	Chat.send_raw(config_goodbye_msg, "grey", false)
# -----------------------------------------------------------------------
