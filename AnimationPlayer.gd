extends AnimationPlayer

onready var m_player : Node2D = get_parent()
onready var m_sprite : Node2D = get_parent().get_node("HeroKnight")
onready var m_animationStr : String = "Idle"

func _ready():
	connect("animation_finished", m_player, "animationFinished")
	
func _onStateChanged(animation: int):
	match animation:
		0:
			m_animationStr = "Idle"
		1:
			m_animationStr = "Run"
		2:
			m_animationStr = "Spell1" #@TODO: casting
		3:
			m_animationStr = "Spell2" #@TODO: casting
	play(m_animationStr)
