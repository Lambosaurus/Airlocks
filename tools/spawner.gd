extends Node3D

enum Location { INSIDE, OUTSIDE }

@export var scene: PackedScene
@export var target: Node3D = self
@export var location: Location = Location.OUTSIDE

@export var frequency: float:
	set(value):
		frequency = value
		$Timer.start(value)
@export var amount: int = 1

func _ready():
	$Timer.timeout.connect(spawn)
	$Timer.start(frequency)

func spawn():
	for idx in amount:
		var node = scene.instantiate()
		match location:
			Location.INSIDE: target.add_child(node)
			Location.OUTSIDE: 
				target.add_sibling(node)
				node.global_position = target.global_position
		
