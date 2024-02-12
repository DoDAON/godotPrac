extends CharacterBody2D

# 최대 속도
const MAX_SPEED = 100.0
# 가속량
const ACCELERATION = 400
# 마찰력
const FRICTION = 400

# 이거 생성하고 _ready()로 생성해도 되긴 함
# var animationPlayer = null

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

@onready var animationPlayer = $AnimationPlayer
# 트리 생성
@onready var animationTree = $AnimationTree
# 트리에서 playback 파라미터를 받아옴 
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

func move_state(delta):
	# 초기화
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# 단위 벡터 계산
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# 단순 움직임
		# velocity = input_vector
		# 증감, 시간에 따른 가속
		# velocity += input_vector * ACCELERATION * delta
		# 증감인데 move_toward를 써서 최대값 지정
		
		# 애니메이션 Idle, Run 상태값에 input_vector 넣기?
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		# 상태 정의
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# 상태 정의
		animationState.travel("Idle")
		# A까지 B가 이동
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# 물리 적용, velocity를 시간 경과만큼 곱함
	# 무브 엔드 콜리드는 충돌하면 멈추는 거
	# move_and_collide(velocity * delta)
	# 무브 앤드 슬라이드는 물리 현상은 그대로
	# 이거 인자 원래 넣어야했는데 velocity, 안 넣어도 되네
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
