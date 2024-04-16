extends Node2D

@export var buneco:RigidBody2D
@export var enemy:RigidBody2D
@export var base:StaticBody2D
@export var base_inimiga:StaticBody2D
var gold_cost = [50, 100, 80, 300, 200]
var gold = 100
var gold_gain = 12
var CD = .9
var cd = .9
var cd_u = .9
var POS_Y 
var POS_X 
var buttons = [false, false, false, false, false]
var start = false
var cd_upgrades = [99E10, 99E10, 99E10, 99E10, 99E10]
var spawn_time = 15
var spawn_enamy_timer = 0
var enamy_upgrades_timer = 0
var level
var win_text = [
	'Parabéns por dominar as constantes.\n Este tipo de função não muda o seu comportamento, independente do valor de ‘x’,\n assim como os guerreiros não mudam seu poder após serem invocados.',
	'Parabéns por dominar a linearidade.\n Funções lineares são do tipo f(x)=ax+b. Essas funções são caracterizadas por comportamento crescente.\n Uma função linear notável é a função identidade, definida por f(x)=x, na qual o valor resultante da função é igual à entrada.\n Esta pode ser usada para fazer o traçado de funções simétricas.',
	'Parabéns por dominar os logaritimos.\n Neste nivel foi apresentado a função f(x)=1/log(x+1), pelo comportamento de crecimento inicial explosivo da função log(x) que é redusido\n gradualmente até atingir um patamar de quase constancia, assim ao invetemos este valor temos um crecimento \ncom decaimento muito grande. Mas porque sera que tivemos que somar 1 ao x? ',
	'Parabéns por dominar o exponencial.\n Funções esponenciais, como a f(x)=4^x usada, são caracteriazadas com uma taxa crecimento explosico, assim estas começam crecendo\n aos poucos porem este crecimento vai almentando. será que existe alguma relação com a logaritica?',
	'Parabéns por dominar senoidais.\n Funções senoidais são um tipo especial de função com um comportamento \"repetitivo\", ou seja, ela é feita for infinitas repetições de um pedaço.',
]
var aux_level = 0
var dialog

func set_up(b:int, life_in:int):
	level = b
	gold = b * gold
	var hbox = get_node("Camera/HBoxContainer")
	if 0 < b and b < 6:
		for a in range(b):
			cd_upgrades[a] = (randi() % 9 + 1) * (level / 4) + 10
			hbox.get_child(a).visible = true
			buttons[a] = true
		for a in range(b, 5):
			hbox.get_child(a).visible = false
			buttons[a] = false
	get_node('Camera').visible = true
	base.setup(1, life_in)
	base_inimiga.setup(-1, life_in)
	start = true

func _ready():
	get_node("Camera").visible = false
	POS_Y = 390
	POS_X = [144, 1030]
	dialog = get_node("Window")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start:
		enamy_upgrades_timer += delta
		spawn_enamy_timer += delta
		gold += gold_gain * delta
		get_node("Camera/Label").text = str(round(gold))
		#var po = get_node("Camera/Label")
		#for a in range(5):
			#po.text+='\n'+str(cd_upgrades[a])
		#po.text+='\n'+str(enamy_upgrades_timer)
		#po.text += '\n'+str(spawn_time-spawn_enamy_timer)
		cd += delta
		cd_u += delta
		if(Input.is_key_pressed(KEY_S) and gold > 100 and cd > CD):
			gold -= 100
			create(1,base.power.duplicate())
			cd = 0
		if spawn_enamy_timer > spawn_time:
			var __power = base_inimiga.power.duplicate()
			create(-1, __power, gold_gain_on_death(__power))
			spawn_enamy_timer -= spawn_time
			if level == 2:
				if spawn_time > 5:
					spawn_time -= .4
			elif level == 3:
				spawn_time = 10 + randi() % 10
			elif level == 4:
				spawn_time = (10 - aux_level) + randi() % 10
				aux_level += 1
				if aux_level == 8:
					aux_level = 0
			elif level == 5:
				aux_level += 1
				if aux_level == 10:
					spawn_time = 1
					aux_level = 0
				elif aux_level == 9:
					spawn_time = 1
				else:
					spawn_time = 10 + randi() % 10
		for a in range(5):
			if enamy_upgrades_timer > cd_upgrades[4-a]:
				enamy_upgrades_timer = 0
				base_inimiga.update(4 - a, 1)
				cd_upgrades[4-a] = (randi() % 9 + 1) * (level / 2) + 10
				for t in range(5):
					if t != a:
						cd_upgrades[4-t] -= 1
				#print(cd_upgrades)
		if(Input.is_key_pressed(KEY_1) and buttons[0] and cd_u > CD):
			_on_const_bnt_pressed()
			cd_u = 0
		if(Input.is_key_pressed(KEY_2) and buttons[1] and cd_u > CD):
			_on_lin_btn_2_pressed()
			cd_u = 0
		if(Input.is_key_pressed(KEY_3) and buttons[2] and cd_u > CD):
			_on_log_btn_3_pressed()
			cd_u = 0
		if(Input.is_key_pressed(KEY_4) and buttons[3] and cd_u > CD):
			_on_exp_btn_4_pressed()
			cd_u = 0
		if(Input.is_key_pressed(KEY_5) and buttons[4] and cd_u > CD):
			_on_sin_btn_5_pressed()
			cd_u = 0
		if base.life <= 0:
			dialog.find_child("Label").text = 'Tente Novamente.\n\n Estude um pouco mais para dominar as funções matemáticas \n\n e derrotar os orcs.'
			dialog.visible = true
			print('lose')
			start = false
		if base_inimiga.life <= 0:
			dialog.find_child("Label").text = win_text[level-1]
			dialog.visible = true
			print('win')
			start = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://level selection.tscn")

func create(team, power, gold = null):
	var b;
	b = buneco.duplicate()
	b.DUPLICATE_SCRIPTS
	b.setup(team,power,Vector2(POS_X[(team - 1) / 2 * -1], POS_Y), gold)
	add_child(b)
		#print(b,'  team ',team)

func gold_gain_on_death(p):
	var g = 0
	for n in range(5):
		g += p[n] * gold_cost[n] / 10
	return g

func gain_gold(g):
	gold += g
	
func _on_const_bnt_pressed():
	update(0)

func _on_lin_btn_2_pressed():
	update(1)

func _on_log_btn_3_pressed():
	update(2)

func _on_exp_btn_4_pressed():
	update(3)

func _on_sin_btn_5_pressed():
	update(4)

func update(n):
	if gold > gold_cost[n]:
		gold -= gold_cost[n]
		base.update(n, 1)
