extends Node2D

enum possibleStates { IDLE, RUNNING, CASTING, STUNNED, SILENCED}
onready var m_state = possibleStates.IDLE
onready var m_sprite : Sprite = $"HeroKnight"
onready var m_animationPlayer : AnimationPlayer = $"AnimationPlayer"
onready var m_stateString : String = "Idle"
onready var m_speed : float = 100
onready var m_movement := Vector2(0,0)

var test ="Test"
signal stateChanged(state)

func _process(delta) -> void:
	handleMovementInput(delta)

func _ready() -> void:
	var result = connect("stateChanged", m_animationPlayer, "_onStateChanged")
	assert(result == 0)#@TODO: Change to OK
	emit_signal("stateChanged", m_state)#@TODO: change signal name to animationChanged

func handleMovementInput(delta : float) -> void:
	m_movement = movementVector()
	match m_state:
		possibleStates.IDLE:
			if(castingInput()):
				m_state = possibleStates.CASTING
				emit_signal("stateChanged", possibleStates.CASTING)
			elif(m_movement != Vector2(0,0)):
				m_state = possibleStates.RUNNING
				emit_signal("stateChanged", possibleStates.RUNNING)
		possibleStates.RUNNING:
			if(castingInput()):
				m_state = possibleStates.CASTING
				emit_signal("stateChanged", possibleStates.CASTING)
			elif(m_movement == Vector2(0,0)):
				m_state = possibleStates.IDLE
				emit_signal("stateChanged", possibleStates.IDLE)
		possibleStates.CASTING:
			m_movement = Vector2(0,0)
		possibleStates.STUNNED:
			m_movement = Vector2(0,0)
		possibleStates.SILENCED:
			if(m_movement != Vector2(0,0)):
				emit_signal("stateChanged", possibleStates.RUNNING)
			if(m_movement == Vector2(0,0)):
				emit_signal("stateChanged", possibleStates.IDLE)
	m_sprite.position += m_movement*m_speed*delta
	if(m_movement.x!= 0):
		m_sprite.flip_h = m_movement.x==-1#@TODO: should be some other classes' responsibility to influence the animation state.

func movementVector() -> Vector2:
	var movement = Vector2(0,0)
	if(Input.is_action_pressed("ui_right") == true):
		movement.x = 1
	elif(Input.is_action_pressed("ui_left") == true):
		movement.x = -1
	if(Input.is_action_pressed("ui_up") == true):
		movement.y = -1
	elif(Input.is_action_pressed("ui_down") == true):
		movement.y = 1
	return movement

func castingInput() -> bool:
	if(Input.is_action_pressed("ui_spell1") == true || Input.is_action_pressed("ui_spell2")): #@TODO:other spells + cooldoown
		return true
	return false

func animationFinished(animation : String) -> void:
	if (animation == "Spell1"):
		m_state = possibleStates.IDLE
		emit_signal("stateChanged", m_state)
	if (animation == "Spell2"):
		m_state = possibleStates.IDLE
		emit_signal("stateChanged", m_state)
