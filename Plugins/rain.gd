extends Node

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

# i 100% didn't get this from vityamod, nope... please trust :(

func is_host(): return Network.GAME_MASTER or Network.PLAYING_OFFLINE

func spawn_raincloud(pos):
	Network._sync_create_actor("raincloud", pos, "hub_entrance", - 1, Network.STEAM_ID)

func _process(delta):
	if is_host():
		var rainclouds = len(get_tree().get_nodes_in_group("raincloud"))
		if rainclouds <= 1:
			spawn_raincloud(Vector3(63,42,0))
			spawn_raincloud(Vector3(150,42,0))
