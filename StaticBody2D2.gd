extends StaticBody2D

var team
var life
var power = [0,0,0,0,0]
var behavior

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('Label').text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node('Label').text = str(life)
	if behavior:
		pass

func setup(team_in,life_in:int=100,comportamento=null):
	team = team_in
	add_to_group(str(team)+'B')
	life = life_in
	behavior = comportamento

func take_damage(enemy_power):
	life = life - enemy_power
