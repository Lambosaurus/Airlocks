extends MultiplayerSpawner

@export_dir var preload_paths: Array[String]

func _enter_tree():
	set_multiplayer_authority(1)
	for path in EntityService.register_dirs(preload_paths):
		add_spawnable_scene(path)
