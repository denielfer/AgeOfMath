extends RigidBody2D

var team = 0
var SPEED:int = 40
var power = [1,0,0,0,0]
var x = 0.01
var hit = false
var idle = false
var gold=0
var y_force = 1
var animation = null

var ally_walk = preload('res://img/Run-Ally.png')
var ally_death = preload('res://img/Dead-Ally.png')
var ally_idle = preload('res://img/Idle-Ally.png')
var ally_punch = preload('res://img/Attack-Ally.png')
var enemy_walk = preload('res://img/Run-Enemy.png')
var enemy_death = preload('res://img/Dead-Enemy.png')
var enemy_idle = preload('res://img/Idle-Enemy.png')
var enemy_punch = preload('res://img/Attack-Enemy.png')

func _ready():
	animation = $Sprite2D/AnimationPlayer

func _process(delta):
	var p = get_power()
	if team != 0:
		x+=delta/10
		var l = get_node('dados')
		l.text = "%2.2f" % [x]
		#l.text = "%2.2f \n %2.2f" % [x, p]
	#str(power[0]) + ' + x*' + str(power[1])+"\n [color=blue]"+str(x)[1] +"\n [color=red]"+str(round(p))
	#l.label_settings.font_color = Color(x,p,0,1)
	if p<0.01 or p == NAN:
		if team == -1:
			get_parent().gain_gold(gold)
		check_animation(team, 'death')
		#animation.play('death')
		await get_tree().create_timer(.1).timeout
		queue_free()

func _physics_process(delta):
	var p = get_power()
	if team != 0:
		$Sprite2D.flip_h = team!=1
		#$Sprite2D.scale = Vector2(log(p)+1, log(p)+1)
		if !hit && !idle:
			check_animation(team, 'walk')
			#if team == 1:
				#animation.play('walk')
			#else:
				#animation.play('walk_enemy')
		var who_colided = move_and_collide(Vector2(SPEED *delta * team,0))
		if who_colided != null and !hit:
			who_colided = who_colided.get_collider()
			if who_colided in get_tree().get_nodes_in_group(str(-1*team)):
				hit = !hit
				#print("power: ",p,' colided with:',who_colided.get_power())
				var a = who_colided.get_power()
				check_animation(team, 'punch')
				#animation.play('punch')
				$puntch_1.play()
				await get_tree().create_timer(.1).timeout
				take_damage(a)
				await get_tree().create_timer(.1).timeout
				hit = !hit
				#print("done")
			elif who_colided in get_tree().get_nodes_in_group(str(-1*team)+'B'):
				check_animation(team, 'punch')
				#animation.play('punch')
				$punch_2.play()
				who_colided.take_damage(p)
				take_damage(p,false)
			else:
				check_animation(team, 'idle')
				#animation.play('idle')


func setup(t:int, p, poss_vect:Vector2,gold_cost=null):
	power = p
	if gold_cost != null:
		gold = gold_cost
	team = t
	if team != 1:
		$Sprite2D.texture = enemy_walk
		$Sprite2D.hframes = 6
	add_to_group(str(t))
	global_position = poss_vect
	var l = get_node("Label")
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

func take_damage(enemy_power,gold_gain=true):
	#print(get_power(), enemy_power)
	#print(get_power(), '->', get_power() - enemy_power)
	var t = get_power() - enemy_power
	if t<= 0.01:
		#print('dead')
		if team == -1 and gold_gain:
			get_parent().gain_gold(gold)
		get_node('CollisionShape2D').queue_free()
		check_animation(team, 'death')
		#animation.play('death')
		await get_tree().create_timer(.1).timeout
		queue_free()
	else:
		power[0] -= enemy_power
		#print(power[0])

func get_power():
	return power[0] + x*power[1] + power[2] * (1/(log(x+1))) + power[3] * 4**x + power[4] * (sin(5*(x+.47))+0.05)

func check_animation(team:int, mode:String):
	if mode == 'walk':
		if team == 1:
			$Sprite2D.texture = ally_walk
			$Sprite2D.hframes = 7
			animation.play('walk')
		else:
			$Sprite2D.texture = enemy_walk
			$Sprite2D.hframes = 6
			animation.play('walk_enemy')
	elif mode == 'death':
		if team == 1:
			$Sprite2D.texture = ally_death
			$Sprite2D.hframes = 6
			animation.play('death')
		else:
			$Sprite2D.texture = enemy_death
			$Sprite2D.hframes = 4
			animation.play('death_enemy')
	elif mode == 'idle':
		if team == 1:
			$Sprite2D.texture = ally_idle
			$Sprite2D.hframes = 4
			animation.play('idle')
		else:
			$Sprite2D.texture = enemy_idle
			$Sprite2D.hframes = 5
			animation.play('idle_enemy')
	elif mode == 'punch':
		if team == 1:
			$Sprite2D.texture = ally_punch
			$Sprite2D.hframes = 5
			animation.play('punch')
		else:
			$Sprite2D.texture = enemy_punch
			$Sprite2D.hframes = 4
			animation.play('punch_enemy')
