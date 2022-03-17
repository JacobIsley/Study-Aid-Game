extends Node2D 

onready var enemy = $Enemy
onready var playerStats = $PlayerStats
onready var buttons = $UI/BattleActionButtons

func _ready():
	start_player_turn()


func start_enemy_turn():
	buttons.hide()
	if enemy != null:
		enemy.attack(playerStats)
		yield(enemy, "end_turn")
	start_player_turn()

func start_player_turn():
	buttons.show()
	playerStats.ap = playerStats.max_ap
	
	yield(playerStats, "end_turn")
	start_enemy_turn()

func _on_Enemy_died():
	buttons.hide()
	enemy = null
