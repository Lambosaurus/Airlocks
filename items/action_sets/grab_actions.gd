extends ActionSet

func get_type(): return "grabing"

func grab(item: Item, actor: Player):
	if item.held: return
	
func throw(item: Item, actor: Player):
	var body = item.physics_body as RigidBody3D
	if not body is RigidBody3D: return
	drop(item, actor)
	body.apply_impulse(actor.strength)
	
func drop(item: Item, actor: Player):
	actor.drop(item)
	
