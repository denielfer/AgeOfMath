extends StaticBody2D

var team
var life
var power = [1,0,0,0,0]
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('Label').text = ""


func _process(delta):
	if started:
		get_node('Label').text = str(round(life))
		var l = get_node('Label2')
		l.text = "y = "
		var f = false
		if power[0] >0:
			l.text +=  str(power[0])
			f = true
		if power[1] >0:
			if f:
				l.text +=  ' + \n'
			l.text +=  str(power[1])+'*X'
			f = true
		if power[2] >0:
			if f:
				l.text +=  ' + \n'
			l.text +=   "%d/log(x+1)" % power[2]
			f = true
		if power[3] >0:
			if f:
				l.text +=  ' + \n'
			l.text +=   "%d*4^x" % power[3]
			f = true
		if power[4] >0:
			if f:
				l.text +=  ' + \n'
			l.text +=  "%d*sin(x)" % power[4]
			f = true

func setup(team_in,life_in:int=100):
	team = team_in
	started = true
	add_to_group(str(team)+'B')
	life = life_in

func take_damage(enemy_power):
	print(life,'->',life - enemy_power)
	life = life - enemy_power

func update(n:int,value:int):
	power[n]+=value
