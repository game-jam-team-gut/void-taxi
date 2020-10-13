extends KinematicBody2D

export (int) var speed = 0 #początkowa szybkość
export (float) var rotation_speed = 1.1 #współczynnik obrotu

var velocity = Vector2() #prędkość
var rotation_dir #kierunek obrotu

func get_input():
	rotation_dir = 0 #początkowy kierunek obrotu
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'): #prawo
		if(speed>55 or speed<-55): #obrót zależny od szybkości, żeby nie dało się obracać w miejscu
			rotation_dir += 1 #kierunek obrotu
	if Input.is_action_pressed('ui_left'): #lewo
		if(speed>55 or speed<-55): #obrót zależny od szybkości, żeby nie dało się obracać w miejscu
			rotation_dir -= 1 #kierunek obrotu
	if Input.is_action_pressed('ui_up'): #przód
		if (speed < 440): #maksymalna szybkość do przodu
			speed=speed+4 #przyspieszenie do przodu
		velocity = Vector2(speed, 0).rotated(rotation)
	else: speed=speed-4 #nie usuwać mi tego
	if Input.is_action_pressed('ui_down'): #tył
		if (speed > -220): #maksymalna szybkość do tyłu
			speed=speed-2 #przyspieszenie do tyłu
			if(speed>0):
				speed=speed-8 #hamowanie
		velocity = Vector2(speed, 0).rotated(rotation)
	else: speed=speed+4 #nie usuwać mi tego
	if InputDefault: #utrzymanie prędkości
		velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
