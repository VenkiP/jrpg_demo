extends Node2D


# Called when the node enters the scene tree for the first time.
#This is a bit too hard coded, it only needs to load the cards that are accessible in the game
#So the world is going to need to keep track of a unique set of card image paths
const FOOL = preload("res://Cards/Assets/Tarot Cats/0. The Fool.png")
const MAGICIAN = preload("res://Cards/Assets/Tarot Cats/1. The Magician.png")
const CARD_SCENE = preload("res://Cards/Card.tscn")

var CARDS: = []

func set_card_visibility(isVisible: bool) -> void:
	for i in CARDS.size():
		var curr_child: Area2D = get_children()[i]
		curr_child.visible = isVisible
	pass

func set_cards(card_count: int) -> void:

	for i in card_count:
		var card_instance = CARD_SCENE.instantiate()
		card_instance.set_name("card" + str(i))
		add_child(card_instance)
		CARDS.append(card_instance)

	var dir := DirAccess.open("res://Cards/Assets/Tarot Cats")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	var card_assets := []
	for file: String in dir.get_files():
		if (file.ends_with(".png")):
			card_assets.append(load(dir.get_current_dir() + "/" + file))
	
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

		print(card_collision_height)
		var setting_asset = card_assets[i]
		curr_child.set_image(setting_asset)
		#Change this from hard coding to proportional to the screen width
		var card_x_pos = current_viewport_width - ((inter_card_margin + card_collision_width) * (i + 1)) - side_margin
		var new_position = Vector2(card_x_pos, current_viewport_height - bottom_margin - card_collision_height)
		curr_child.position = new_position


# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	set_cards(6)
	set_card_visibility(true)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
