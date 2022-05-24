extends Node
#tab1
export (NodePath) onready var tabContainer = get_node(tabContainer) as TabContainer
export (NodePath) onready var ddi = get_node(ddi) as SpinBox
export (NodePath) onready var WWPer1InsLabel1 = get_node(WWPer1InsLabel1) as RichTextLabel
export (NodePath) onready var InsPer1WWLabel1 = get_node(InsPer1WWLabel1) as RichTextLabel
export (NodePath) onready var new_line2 = get_node(new_line2) as HBoxContainer
export (NodePath) onready var static2Box = get_node(static2Box) as VBoxContainer
export (NodePath) onready var WW_morning_cell = get_node(WW_morning_cell) as RichTextLabel
export (NodePath) onready var WW_afternoon_cell = get_node(WW_afternoon_cell) as RichTextLabel
export (NodePath) onready var WW_evening_cell = get_node(WW_evening_cell) as RichTextLabel
export (NodePath) onready var new_line3 = get_node(new_line3) as VBoxContainer
export (NodePath) onready var weglowodany = get_node(weglowodany) as SpinBox
export (NodePath) onready var blonnik = get_node(blonnik) as SpinBox
export (NodePath) onready var bialko = get_node(bialko) as SpinBox
export (NodePath) onready var tluszcz = get_node(tluszcz) as SpinBox
export (NodePath) onready var WWandWBT = get_node(WWandWBT) as RichTextLabel

#tab2
export (NodePath) onready var WWPer1InsLabel2 = get_node(WWPer1InsLabel2) as RichTextLabel
export (NodePath) onready var WWPer1InsResultLabel2 = get_node(WWPer1InsResultLabel2) as RichTextLabel
export (NodePath) onready var EnteredDDI = get_node(EnteredDDI) as RichTextLabel
export (NodePath) onready var proporcja = get_node(proporcja) as RichTextLabel
export (NodePath) onready var dzialanie = get_node(dzialanie) as RichTextLabel
export (NodePath) onready var WWrano = get_node(WWrano) as RichTextLabel
export (NodePath) onready var WWpopoludniu = get_node(WWpopoludniu) as RichTextLabel
export (NodePath) onready var WWwieczore = get_node(WWwieczore) as RichTextLabel

export (int) var ddi_value
export (int) var static_1 = 450
var i_1WW

func _ready():
	ddi.get_line_edit().grab_focus()
	print("----------------------")
	print("----------------------")
	print("----------------------")
	print("Przelicznik WW")
	tabContainer.set_tab_disabled(1, true)
		
func calculate_Insuline_per_1WW():
	ddi_value = ddi.value
	var i_1W = stepify((static_1/ddi_value), 0.0001)
	i_1WW = stepify(i_1W/10,0.1)
	var i_1WW_text = "%s : %s = %s ==>> Czyli 1 jednostka insuliny zbija %s Węglowodanów"
	
	#tab1
	WWPer1InsLabel1.bbcode_text = "[b][u][i]%s WW[/i][/u][/b]  <-- w przybliżeniu tyle WW " %i_1WW
	WWPer1InsLabel1.bbcode_text += "zbija 1 jednostka insuliny przy zerowej oporności"
	#tab2
	WWPer1InsLabel2.bbcode_text = i_1WW_text % [str(static_1),str(ddi_value),str(i_1W), str(i_1W)]
	WWPer1InsResultLabel2.bbcode_text = "czyli około: [b][i][u]%s WW[/u][/i][/b]" %i_1WW
	

func calculate_WW_per_1Insuline():
	var WW_1i = stepify(1/i_1WW,0.0001)
	var WW_morning = stepify(WW_1i*1.5,0.01)
	var WW_afternoon = stepify(WW_1i,0.01)
	var WW_evening = stepify(WW_1i*1.3,0.01)
	new_line2.visible = true
		
	#tab1
	InsPer1WWLabel1.bbcode_text = "[b][u][i]%s[/i][/u][/b]  <--  w przybliżeniu tyle jednostek insuliny należy podać na 1WW" %[WW_1i]
	WW_morning_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %WW_morning
	WW_afternoon_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %WW_afternoon
	WW_evening_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %WW_evening
	
	#tab2
	proporcja.bbcode_text = "Następnie obliczamy z proporcji: \n1j --> %s WW \nx -> 1 WW" %i_1WW
	dzialanie.bbcode_text = "x = (1WW * 1j) / %s = [b][u]%s[/u][/b]  <--  tyle jednostek insuliny należy podać na 1WW" %[i_1WW, WW_1i]
	WWrano.bbcode_text = "[b]Rano[/b] jest największa oporność, należy podać 50% więcej insuliny więc:\n" 
	WWrano.bbcode_text+= "[b]%s[/b] * 1,5 = [b][i][u]%s[/u][/i][/b] jednostki insuliny na 1 WW" %[str(WW_1i), str(WW_morning)]
	WWpopoludniu.bbcode_text = "[b]Popołudniu[/b] jest standardowa oporność więc:\n" 
	WWpopoludniu.bbcode_text+= "[b][i][u]%s[/u][/i][/b] jednostki insuliny na 1 WW" %[str(WW_afternoon)]
	WWwieczore.bbcode_text = "[b]Wieczorem[/b]jest podwyższona oporność, należy podać 30% więcej insuliny więc:\n" 
	WWwieczore.bbcode_text+= "[b]%s[/b] * 1,3 = [b][i][u]%s[/u][/i][/b] jednostki insuliny na 1 WW" %[str(WW_1i), str(WW_evening)]
	EnteredDDI.bbcode_text = "Twoje DDI: [color=yellow][b][i]%s[/i][/b][/color]" %ddi_value

func calculate_WW_WBT_values():
	var WW_value = (weglowodany.value - blonnik.value)/10
	WWandWBT.bbcode_text = "[b][i]WW = %s[/i][/b]" %WW_value

func _on_CalculateButton_pressed():
	calculate_Insuline_per_1WW()
	calculate_WW_per_1Insuline()
	tabContainer.set_tab_disabled(1, false)
	new_line3.visible = true


func _on_CalculateButton2_pressed():
	calculate_WW_WBT_values()
