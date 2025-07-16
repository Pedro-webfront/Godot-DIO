extends CharacterBody2D

@export var speed: float = 3
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var  sprite: Sprite2D = $Sprite2D

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0


func _process(delta: float) -> void:
	read_input()
	#Processar animação e rotação de sprite
	play_random_idle_animation()
	rotate_sprite()
	
	update_attack_cooldown(delta)
	#ataque
	if Input.is_action_just_pressed("attack"):
		attack()
		

func _physics_process(delta: float) -> void:

	#modificar a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.10
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
	if attack_cooldown <= 0.0:
		is_attacking = false
		is_running = false
		animation_player.play("Idle")

func attack() -> void:
	if is_attacking:
		return
	
	#Tocar animação
	animation_player.play("attack_right1")
	
	#configurar temporizador
	attack_cooldown = 0.6
	
	#marcar ataque
	is_attacking = true

func read_input() -> void:
		#Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
			#obter o input_vector
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down", 0.15)
	
		#apagar deadzone do input vector
	var deadzone = 0.15
	if  abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if  abs(input_vector.y) < 0.15:
		input_vector.y = 0.0

func play_random_idle_animation() -> void:
	#Trocar animação
	if was_running != is_running:
		if is_running:
			animation_player.play("Run")
		else:
			animation_player.play("Idle")

func rotate_sprite() -> void:
		#Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
	
