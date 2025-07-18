class_name Enemy
extends Node2D

@export var health: int = 10

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida é total é ", health)
