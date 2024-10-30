extends Node


@onready var Coin = load("res://moneda/moneda.tscn")
@onready var Powerup = load("res://powerup/powerup.tscn")
@onready var Cactus = load("res://obstaculos/cactus.tscn")
@export var tiempoJuego : int

var nivel := 1
var score
var time_left
@onready var screensize = Vector2(450,720)
@onready var player = $Player
@onready var HUD = $HUD
var playing = false

func _ready():
	randomize()
	player.ventanaTm = screensize
	player.hide()

func nuevoJuego():
	
	$SpawnPowerupTimer.start()
	$InicioAudioStreamPlayer.play()
	playing = true
	nivel = 1
	score = 0
	time_left = 10
	player.inicio($InicioMarker2d.position)
	player.show()
	$JuegoTimer.start()
	agregaMonedas()
	HUD.actScore(score)
	HUD.actTimer(time_left)
	
	#Los cactus seguian en el nivel despues de cada nuevo juego
	var cactus = get_tree().get_nodes_in_group("enemigos")
	for cact in cactus:
		cact.queue_free()


#Para que el cactus no se cree encima del jugador

func crearCactus():
	var cactus = Cactus.instantiate()
	add_child(cactus)
	randomize()
	cactus.position = get_random_spawn_pos()

#Creamos una nueva funcion iterativa si el rango en el que aparece el cactus es muy cercano al jugador
var safe_range  := 60
func get_random_spawn_pos() -> Vector2:
	var spawn_pos := Vector2(randf_range(0,screensize.x) , randf_range(0,screensize.y))
	if abs(spawn_pos - player.position) < Vector2(safe_range,safe_range):
		spawn_pos = get_random_spawn_pos()
	return spawn_pos
	
	
	
func agregaMonedas():
	crearCactus()
	for i in range(4+nivel):
		var coin = Coin.instantiate()
		$ContenedorMonedas.add_child(coin)
		coin.screensize = screensize
		coin.position = Vector2(randf_range(0,screensize.x) , randf_range(0,screensize.y))

func _process(_delta):
	if playing and $ContenedorMonedas.get_child_count() == 0:
		nivel+=1
		time_left += 5
		agregaMonedas()


func _on_juego_timer_timeout():
	time_left-=1
	HUD.actTimer(time_left)
	if time_left <= 0:
		game_over()
		

func game_over():
	$MorirAudioStreamPlayer.play()
	playing = false
	$JuegoTimer.stop()
	for moneda in $ContenedorMonedas.get_children():
		moneda.queue_free()
	HUD.mostrar_gameOver()
	player.morirse()

func _on_player_recolectar(areaRecolectada):
	match areaRecolectada:
		"moneda":
			$CoinAudioStreamPlayer.play()
			score += 1
			HUD.actScore(score)
		"powerup":
			$PowerupAudioStreamPlayer.play()
			time_left+=3


func _on_player_herirse():
	$MorirAudioStreamPlayer.play()
	game_over()


func _on_spawn_powerup_timer_timeout():
	if playing:
		$SpawnPowerupTimer.wait_time = randi_range(3,10)
		var powerup = Powerup.instantiate()
		add_child(powerup)
		powerup.position = Vector2(randf_range(0,screensize.x) , randf_range(0,screensize.y))
