extends CharacterBody2D

@export var speed: float = 3
@export var sword_damage: int = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea

var input_vector: Vector2 = Vector2(0, 0)
var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0


func _process(delta: float) -> void:
	GameManager.player_position = position
	read_input()
	update_animations() # NOVA função que centraliza a lógica de animação
	rotate_sprite()
	
	update_attack_cooldown(delta)
	
	if Input.is_action_just_pressed("attack"):
		attack()


func _physics_process(_delta: float) -> void: # Usar _delta para remover o aviso de variável não usada
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.10
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

# ATUALIZADA: Agora só controla o estado de ataque, sem tocar animações
func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false

func attack() -> void:
	if is_attacking:
		return
	
	# Inicia a animação de ataque
	animation_player.play("attack_right1")
	
	attack_cooldown = 0.6
	is_attacking = true
	
func deal_damage_to_enemies() ->  void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			
			if dot_product >= 0.4:
				enemy.damage(sword_damage)


func read_input() -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	is_running = not input_vector.is_zero_approx()
	
	# Seu código para a 'deadzone' manual está correto, mas note que a função
	# Input.get_vector() já tem um parâmetro de deadzone que você pode usar.


# NOVA FUNÇÃO: Substitui 'play_random_idle_animation()'
func update_animations() -> void:
	# Prioridade 1: Atacando
	if is_attacking:
		# Deixa a animação de ataque tocar até o fim. O 'return' impede
		# que qualquer outra animação (correr/parado) a substitua.
		return

	# Prioridade 2: Correndo
	if is_running:
		# Só toca a animação se ela já não for a de corrida
		if animation_player.current_animation != "Run":
			animation_player.play("Run")
	# Prioridade 3: Parado
	else:
		# Só toca a animação se ela já não for a de parado
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")


func rotate_sprite() -> void:
	# Sem alterações, esta função está correta
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
