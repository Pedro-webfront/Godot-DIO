extends CharacterBody2D

@export var speed: float = 3
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var  sprite: Sprite2D = $Sprite2D

var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0


func _process(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("Idle")

func _physics_process(delta: float) -> void:
	#obter o input_vector
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down", 0.15)
	
	#apagar deadzone do input vector
	var deadzone = 0.15
	if  abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if  abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	#modificar a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.10
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	#Atualizar o is_running
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	#Trocar animação
	if was_running != is_running:
		if is_running:
			animation_player.play("Run")
		else:
			animation_player.play("Idle")

	#Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
		#desmarcar flip_h do Sprite2D
		pass
	elif input_vector.x < 0:
		sprite.flip_h = true
		#Marcar flip_h do Sprite2D
		pass
	
	#ataque
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack() -> void:
	if is_attacking:
		return
	
	#Tocar animação
	animation_player.play("attack_right1")
	
	#configurar temporizador
	attack_cooldown = 0.6
	
	#marcar ataque
	is_attacking = true
