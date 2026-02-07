extends Node2D

# This is the orchestration layer that should call down to the card manager to send signals to things I believe.
# Called when the node enters the scene tree for the first time.
var playerManager
var cardManager

func _ready() -> void:
	playerManager = get_child(2)
	cardManager = get_child(3)

	for character in playerManager.get_children():
		print(character.load_player)
		character.load_player.connect(load_character)
	cardManager.end_turn.connect(end_turn)
		
	playerManager.initialize_first_character()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func end_turn(character: String):
	print("Ending turn for: " + character)
	#This has to signal to the player manager that it is now time to move the focus down the list
	playerManager._on_end_turn_next_player()

# Call this function when the battle scene gets a signal that a play character has been put into focus
# We can also move the attack signal to go up to this component and call the function on the card manager
func load_character(character: String):
	print(character)
	if (character == 'Brad'):
		#Only load fool cards
		print('Load' + character)
		var cards: Array[String] = ["12TheHangedMan", "13Death"]
		cardManager.set_cards(cards, character)
	else:
		var cards: Array[String] = ["2ThePriestess", "6TheLovers"]
		cardManager.set_cards(cards, character)
