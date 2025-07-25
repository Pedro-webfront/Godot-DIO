class_name Enemy
extends Node2D

@export var health: int = 10
@export var death_prefab: PackedScene

func damage(amount: int) -> void:
	health -= amount
	print("O inimigo recebeu dano de ", amount, ". A vida é total é ", health)
	
	modulate = Color.CRIMSON
	
	# Cria o Tween e encadeia todas as chamadas no mesmo objeto.
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)

	if health <= 0:
		die()

	#processar a morte
	if health <= 0:
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
