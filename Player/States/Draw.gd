extends PlayerState

"""
Draw SWORD
"""

var hit: = false

func unhandled_input(event:InputEvent)->void:
	#doesn't matter for the state but need to track direction pressing
	if event.is_action_pressed("attack"):
		hit = true
	else:
		player.unhandled_input(event)

func physics_process(delta:float)->void:
	velocity_logic(delta)
	gravity_logic(delta)
	player.collision_logic()
	player.ground_update_logic()

func velocity_logic(delta:float)->void:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.acceleration * delta)

func gravity_logic(delta:float)->void:
	if !player.is_grounded:
		player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.velocity.y, player.fall_limit)

func state_check(anim:String = '')->void:
	if !anim.empty():
		if hit:
			_state_machine.transition_to("Attack", {})
		else:
			_state_machine.transition_to("Idle", {})

func enter(msg:Dictionary = {})->void:
	animation.play("Draw")
	animation.connect("animation_finished", self, "state_check")

func exit()->void:
	animation.disconnect("animation_finished", self, "state_check")
	player.sword_is_active = true
	hit = false
