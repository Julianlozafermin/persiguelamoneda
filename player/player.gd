extends Area2D


@export var velocidad : int 
var movimientoInput := Vector2()
var ventanaTm = Vector2(450,720)

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2d

signal recolectar
signal herirse

func _ready():
	area_entered.connect(_on_player_area_entered)



func _process(_delta):
	moverPersonaje(_delta)
	if movimientoInput.length() > 0:
		sprite.animation = "run"
		if movimientoInput.x != 0:
			sprite.flip_h = movimientoInput.x < 0
	else:
		sprite.animation = "idle"

func moverPersonaje(delta):
	movimientoInput.x = Input.get_action_strength("DERECHA") - Input.get_action_strength("IZQUIERDA")
	movimientoInput.y = Input.get_action_strength("ABAJO") - Input.get_action_strength("ARRIBA")
#	movimientoInput.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	movimientoInput.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	position += movimientoInput.normalized() * velocidad * delta
	
	position.x = clamp(position.x, 0, ventanaTm.x)
	position.y = clamp(position.y, 0, ventanaTm.y)
	

func inicio(pos):
	position = pos
	sprite.play("idle")
	set_process(true)

func morirse():
	sprite.play("hurt")
	set_process(false)

func _on_player_area_entered(area):
	if area.is_in_group("monedas"):
		area.recoger()
		emit_signal("recolectar","moneda")
	if area.is_in_group("enemigos"):
		emit_signal("herirse")
		
	if area.is_in_group("powerups"):
		area.recoger()
		emit_signal("recolectar","powerup")

