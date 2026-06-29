extends Item

@onready var light = $Light

func _process(_delta):
	$Light.visible = activated
	$Glow.visible = activated
	
func _ready():
	mesh = $MeshInstance3D
	hold_position = $HoldPosition
