extends Node3D

@export var item_type: ItemType
@export var target: Node3D = self # For global position

@export var frequency: float:
    set(value):
        frequency = value
        start_timer()
        
@export var amount: int = 1
@export var variability = 0.0

var item_scene = preload("res://items/item.tscn")

func start_timer():
    if multiplayer and not multiplayer.is_server() or not frequency: return
    $Timer.start(frequency)

func _ready():
    if multiplayer.is_server():
        $Timer.timeout.connect(spawn_items)
        start_timer()
    
func get_randomized_offset():
    if not variability: return Vector3.ZERO
    
    return Vector3(randfn(0, variability), randfn(0, variability), randfn(0, variability))
        
func get_spawn_position():
    return target.global_position + get_randomized_offset()

func spawn_items():
    if not multiplayer.is_server(): return
    
    for idx in amount:
        spawn_item()
        
func spawn_item():
    var item := SpawnHandler.spawn(item_scene, get_spawn_position()) as Item
    item.item_type = item_type
    item.init_type()
    
    return item
