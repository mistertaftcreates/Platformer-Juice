extends KinematicBody2D

#region declaring variables
enum{IDLE, RUN, JUMP, HURT, DASH, ATTACK, CRASH}
var state;
var anim;
var new_anim;

export (int) var jump_speed;
export (int) var run_speed;
export (int) var gravity;
var velocity = Vector2();

func _ready():
	change_state(IDLE);

func change_state(new_state):
	state = new_state;
	match state:
		IDLE:
			new_anim = "idle";
		RUN:
			new_anim = "run";
		JUMP:
			new_anim = "jump";
		HURT:
			new_anim = "hurt";
		ATTACK:
			new_anim = "attack";

func _physics_process(delta):
	velocity.y += gravity * delta;
	
	if(velocity.y > 0):
		velocity.y += 15;
	
	get_input();
	
	velocity = move_and_slide(velocity, Vector2(0, -1));
	
	if new_anim != anim:
		anim = new_anim;
		$AnimatedSprite.play(anim);

func get_input():
	if state == HURT:
		return;
	
	var right = Input.is_action_pressed("ui_right");
	var left = Input.is_action_pressed("ui_left");
	var jump = Input.is_action_just_pressed("jump");
	var jump_counter = 60;
	
	velocity.x = 0;
	if right:
		velocity.x += run_speed;
		$AnimatedSprite.flip_h = false;
	if left:
		velocity.x -= run_speed;
		$AnimatedSprite.flip_h = true;
	if jump && is_on_floor():
		change_state(JUMP);
		velocity.y = -jump_speed;
	if is_on_floor():
		jump_counter = 60;
		
	if state == IDLE && velocity.x != 0:
		change_state(RUN);
	if state == RUN && velocity.x == 0:
		change_state(IDLE);
	if state in [IDLE, RUN] && !is_on_floor():
		change_state(JUMP);
	if state == JUMP && is_on_floor():
		change_state(IDLE);
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

