extends Area2D

@onready var card_image = $"CardImage"
var card_name
signal use_card

func set_card_name(name: String) -> void:
	card_name = name

func set_image(path: Resource) -> void:
	card_image.texture = path
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed() 
	and event.button_index == MOUSE_BUTTON_LEFT):
		#We have to emit a payload so that we can do things like different types of cards. Define a card class
		use_card.emit(name)
