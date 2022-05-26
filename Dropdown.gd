extends Node #"res://Przelicznik.gd"

export (NodePath) onready var dropdown1 = get_node(dropdown1) as OptionButton
export (NodePath) onready var dropdown2 = get_node(dropdown2) as OptionButton


func _ready():
	add_items_to_dropdown()
#	print (WW_morning_string)

func add_items_to_dropdown():
	dropdown1.add_item("Rano ")
	dropdown1.add_item("Popołudniu")
	dropdown1.add_item("Wieczorem")
	dropdown1.add_item("Rano/2")
	dropdown1.add_item("Popołudniu/2")
	dropdown1.add_item("Wieczorem/2")
	dropdown1.add_item("Wpisz Ręcznie")
	dropdown1.select(5)
	dropdown2.add_item("Rano")
	dropdown2.add_item("Popołudniu")
	dropdown2.add_item("Wieczorem")
	dropdown2.add_item("Rano/2")
	dropdown2.add_item("Popołudniu/2")
	dropdown2.add_item("Wieczorem/2")
	dropdown2.add_item("Wpisz Ręcznie")

#func add_items_to_dropdown2():
#	dropdown2.add_item("Rano")
#	dropdown2.add_item("Popołudniu")
#	dropdown2.add_item("Wieczorem")
#	dropdown2.add_item("Rano/2")
#	dropdown2.add_item("Popołudniu/2")
#	dropdown2.add_item("Wieczorem/2")
#	dropdown2.add_item("Wpisz Ręcznie")
