extends Node

export (NodePath) onready var ddi = get_node(ddi) as SpinBox
export (NodePath) onready var InsPer1WWLabel = get_node(InsPer1WWLabel) as RichTextLabel
export (NodePath) onready var InsPer1WWResultLabel = get_node(InsPer1WWResultLabel) as RichTextLabel
export (NodePath) onready var new_line2 = get_node(new_line2) as VBoxContainer
export (NodePath) onready var proporcja = get_node(proporcja) as RichTextLabel
export (NodePath) onready var dzialanie = get_node(dzialanie) as RichTextLabel
export (NodePath) onready var WWrano = get_node(WWrano) as RichTextLabel
export (NodePath) onready var WWpopoludniu = get_node(WWpopoludniu) as RichTextLabel
export (NodePath) onready var WWwieczore = get_node(WWwieczore) as RichTextLabel
export (NodePath) onready var zestawienie = get_node(zestawienie) as RichTextLabel
export (NodePath) onready var static2Box = get_node(static2Box) as VBoxContainer
export (NodePath) onready var zestawienieBox = get_node(zestawienieBox) as Container
export (NodePath) onready var WW_morning_cell = get_node(WW_morning_cell) as RichTextLabel
export (NodePath) onready var WW_afternoon_cell = get_node(WW_afternoon_cell) as RichTextLabel
export (NodePath) onready var WW_evening_cell = get_node(WW_evening_cell) as RichTextLabel

export (int) var ddi_value
export (int) var static_1 = 450
var i_1WW

func _ready():

	ddi.get_line_edit().grab_focus()
	print("----------------------")
	print("----------------------")
	print("----------------------")
	print("Przelicznik WW")
		
func calculate_Insuline_per_1WW():
	ddi_value = ddi.value
	var i_1W = stepify((static_1/ddi_value), 0.0001)
	i_1WW = stepify(i_1W/10,0.1)
	
	print (i_1W)
	var i_1WW_text = "%s : %s = %s ==>> Czyli 1 jednostka insuliny zbija %s Węglowodanów"
	var i_1WW_text_values = i_1WW_text % [str(static_1),str(ddi_value),str(i_1W), str(i_1W)]
	InsPer1WWLabel.bbcode_text = i_1WW_text_values
	InsPer1WWResultLabel.bbcode_text = "czyli około: [b][i][u]%s WW[/u][/i][/b]" %i_1WW
#	print(InsPer1WWLabel.bbcode_text + " " + InsPer1WWResultLabel.bbcode_text)

func calculate_WW_per_1Insuline():
	var WW_1i = stepify(1/i_1WW,0.0001)
	var WW_morning = stepify(WW_1i*1.5,0.01)
	var WW_afternoon = stepify(WW_1i,0.01)
	var WW_evening = stepify(WW_1i*1.3,0.01)
	new_line2.visible = true
	proporcja.bbcode_text = "Następnie obliczamy z proporcji: \n1j -> %s WW \nx -> 1 WW" %i_1WW
	dzialanie.bbcode_text = "x = (1WW * 1j) / %s = [b][u]%s[/u][/b] tyle jednostek insuliny należy podać na 1WW" %[i_1WW, WW_1i]
	WWrano.bbcode_text = "[b]Rano[/b] jest największa oporność, należy podać 50% więcej insuliny więc:\n" 
	WWrano.bbcode_text+= "[b]%s[/b] * 1,5 = [b][i][u]%s[/u][/i][/b] jednostki insuliny na 1 WW" %[str(WW_1i), str(WW_morning)]
	WWpopoludniu.bbcode_text = "[b]Popołudniu[/b] jest standardowa oporność więc:\n" 
	WWpopoludniu.bbcode_text+= "[b][i][u]%s[/u][/i][/b] jednostki insuliny na 1 WW" %[str(WW_afternoon)]
	WWwieczore.bbcode_text = "[b]Wieczorem[/b]jest podwyższona oporność, należy podać 30% więcej insuliny więc:\n" 
	WWwieczore.bbcode_text+= "[b]%s[/b] * 1,3 = [b][i][u]%s[/u][/i][/b] jednostki insuliny na 1 WW" %[str(WW_1i), str(WW_evening)]
	
	zestawienie.bbcode_text = "[table=2][cell][color=yellow]Rano[/color][/cell]" 
	zestawienie.bbcode_text += "[cell][color=green][b]    %s[/b][/color][/cell]" %WW_morning
	zestawienie.bbcode_text += "[cell][color=yellow]Popołudniu[/color][/cell]"
	zestawienie.bbcode_text += "[cell][color=green][b]    %s[/b][/color][/cell]" %WW_afternoon
	zestawienie.bbcode_text += "[cell][color=yellow]Wieczorem[/color][/cell]"
	zestawienie.bbcode_text += "[cell][color=green][b]    %s[/b][/color][/cell][/table]" %WW_evening

	WW_morning_cell.bbcode_text = "[color=green][b][i]%s[/i][/b][/color]" %WW_morning
	
	print(proporcja.bbcode_text + str(WW_morning))

func _on_CalculateButton_pressed():
	calculate_Insuline_per_1WW()
	calculate_WW_per_1Insuline()
	
