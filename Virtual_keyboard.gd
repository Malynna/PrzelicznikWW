extends Control


onready var button_1 = $VBoxContainer/HBoxContainer/Button_1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_1_pressed():
	button_1.get_text()
	print(button_1.get_text())
	OS.show_virtual_keyboard()
