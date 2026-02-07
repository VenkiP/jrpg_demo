extends Node2D


# Called when the node enters the scene tree for the first time.
#This is a bit too hard coded, it only needs to load the cards that are accessible in the game
#So the world is going to need to keep track of a unique set of card image paths
const CARD_SCENE = preload("res://Cards/Card.tscn")
var CARD_ASSETS = {}

var CARDS: = []
var current_character

signal end_turn

@onready var card_turn: VBoxContainer = $"../CardTurn/choice"

func set_card_visibility(isVisible: bool) -> void:
	for i in CARDS.size():
		var curr_child: Area2D = get_children()[i]
		curr_child.visible = isVisible
	pass

func process_card_usage(old: String):
	#Maybe the node can follow a naming convention of (card owner, card name, instance number?)
	#This may not be the best way because there can, will, and should
	#be duplicate cards
	var used_card = get_node(old)
	#We need to revisit card management because removing a child is different than freeing queue. The latter is what actually frees the memory
	remove_child(used_card)
	var used_card_index = CARDS.find(used_card)
	CARDS.remove_at(used_card_index)
	pass

func set_cards(cards: Array[String], character: String) -> void:
	current_character = character
	for card in cards:
		var card_instance = CARD_SCENE.instantiate()
		card_instance.use_card.connect(process_card_usage)
#		This does not properly handle duplicates so we need to do
		card_instance.set_name(card)
		add_child(card_instance)
		CARDS.append(card_instance)

	var bottom_margin = 0
	var current_viewport_height = get_viewport_rect().size.y
	var current_viewport_width = get_viewport_rect().size.x
	#I need a side margin separate from between cards margin
	var side_margin = 200
	var inter_card_margin = 10
	
	#Make this dynamic so that it can just be passed a list of cards and it can figure out its render positions
	for i in CARDS.size():
		var curr_child: Area2D = get_children()[i]
		var card_collision_height = curr_child.get_child(1).shape.size.y
		var card_collision_width = curr_child.get_child(1).shape.size.x

		#Notice how it does it based on the raw node name, this is not good and we have to fix this with card duplications
		var setting_asset = CARD_ASSETS[curr_child.get_name()]
		curr_child.set_image(setting_asset)
		#Change this from hard coding to proportional to the screen width
		var card_x_pos = current_viewport_width - ((inter_card_margin + card_collision_width) * (i + 1)) - side_margin
		var new_position = Vector2(card_x_pos, current_viewport_height - bottom_margin - card_collision_height)
		curr_child.position = new_position
		
	set_card_visibility(false)

func set_max_number_of_cards_playable() -> void:
	pass

func load_deck() -> void:
	pass

func normalize_asset_name(name: String) -> String:
	var removed_periods = name.remove_chars(".")
	var removed_spaces = removed_periods.remove_chars(" ")
	return removed_spaces
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var dir := DirAccess.open("res://Cards/Assets/Tarot Cats")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		if (file.ends_with(".png")):
			var cardName = file.substr(0, file.length() - 4)
			var normalizedCardName = normalize_asset_name(cardName)
			CARD_ASSETS[normalizedCardName] = load(dir.get_current_dir() + "/" + file)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_attack_pressed() -> void:
	set_card_visibility(true)
	pass # Replace with function body.


func _on_end_turn_pressed() -> void:
	#End turn has to notify that the turn has ended sot that the player manage changes focus of the player
	for card in CARDS:
		remove_child(card)
	CARDS.clear()
	card_turn.hide()
	end_turn.emit(current_character)
