extends Node

var _entity_scenes: Dictionary[String, String] = {}

func register_dirs(dir_paths: Array[String]):
	var reducer = func(a,b): return a + register_dir.call(b)
	return dir_paths.reduce(reducer, [])

func register_dir(dir_path: String, root_name = dir_path):
	var dir := DirAccess.open(dir_path)
	var registered_scenes = []
	if dir:
		for file in dir.get_files():
			if not file.ends_with(".tscn"): continue
			
			var scene_name = "{root_name}/{scene_name}".format({"root_name": root_name, "scene_name": file})
			registered_scenes.append(register_scene(scene_name))
		for subdir_path in dir.get_directories():
			registered_scenes += register_dir(subdir_path)
	else: print("Failed to open dir: ", dir_path)
	
	return registered_scenes

func register_scene(scene_path: String, _key = scene_path.get_basename()):
	_entity_scenes[scene_path] = scene_path
	
	return scene_path
