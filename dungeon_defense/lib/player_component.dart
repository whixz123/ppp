import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'game_controller.dart';
import 'magic_projectile.dart';

enum PlayerDirection { up, down, right, left }
enum PlayerState { 
  idleUp, idleDown, idleRight, idleLeft, 
  walkUp, walkDown, walkRight, walkLeft, 
  attackUp, attackDown, attackRight, attackLeft 
}

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<GameController>, CollisionCallbacks {
  static const double speed = 150.0;
  Vector2 velocity = Vector2.zero();
  JoystickComponent? joystick;

  bool isAttacking = false;
  PlayerDirection currentDirection = PlayerDirection.down;

  PlayerComponent({this.joystick}) : super(size: Vector2.all(96), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // 1. Memuat Gambar Idle / Berjalan (Satu Pose)
    final imgUp = await game.images.load('heroes/hero utama_keatas.png');
    final imgDown = await game.images.load('heroes/hero utama_kebawah.png');
    final imgRight = await game.images.load('heroes/hero utama_kekanan.png');
    final imgLeft = await game.images.load('heroes/hero utama_kekiri.png');

    // 2. Memuat Gambar Animasi Serangan Sihir
    final atkUp = await game.images.load('heroes/hero utama_keatas gerakan menyihir.png');
    final atkDown = await game.images.load('heroes/hero utama_kebawah gerakan menyihir.png');
    final atkRight = await game.images.load('heroes/hero utama_kekanan gerakan menyihir.png');
    final atkLeft = await game.images.load('heroes/hero utama_kekiri gerakan menyihir.png');

    // Fungsi pembantu untuk membuat animasi
    SpriteAnimation createAnim(var image, int amount, double w, double h, {bool loop = true}) {
      return SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: amount, 
          stepTime: 0.15, 
          textureSize: Vector2(w, h), 
          loop: loop
        ),
      );
    }

    // Assign animasi ke state dengan membagi ukurannya secara presisi agar tidak tumpang tindih (double)
    animations = {
      // Idle & Walk menggunakan 1 frame
      PlayerState.idleUp: createAnim(imgUp, 1, 76, 86),
      PlayerState.idleDown: createAnim(imgDown, 1, 65, 81),
      PlayerState.idleRight: createAnim(imgRight, 1, 65, 80),
      PlayerState.idleLeft: createAnim(imgLeft, 1, 66, 84),
      
      PlayerState.walkUp: createAnim(imgUp, 1, 76, 86),
      PlayerState.walkDown: createAnim(imgDown, 1, 65, 81),
      PlayerState.walkRight: createAnim(imgRight, 1, 65, 80),
      PlayerState.walkLeft: createAnim(imgLeft, 1, 66, 84),

      // Attack: atas(3 frame), bawah(3 frame), kanan(1 frame), kiri(1 frame)
      PlayerState.attackUp: createAnim(atkUp, 3, 231 / 3, 86, loop: false),
      PlayerState.attackDown: createAnim(atkDown, 3, 214 / 3, 81, loop: false),
      PlayerState.attackRight: createAnim(atkRight, 1, 74, 84, loop: false),
      PlayerState.attackLeft: createAnim(atkLeft, 1, 74, 81, loop: false),
    };

    current = PlayerState.idleDown;

    // Hitbox disesuaikan ke tengah karakter
    add(RectangleHitbox(
      position: Vector2(size.x / 2 - 15, size.y / 2 - 10),
      size: Vector2(30, 40),
    ));
  }

  void attack() {
    if (isAttacking) return;
    
    isAttacking = true;
    
    switch (currentDirection) {
      case PlayerDirection.up: current = PlayerState.attackUp; break;
      case PlayerDirection.down: current = PlayerState.attackDown; break;
      case PlayerDirection.right: current = PlayerState.attackRight; break;
      case PlayerDirection.left: current = PlayerState.attackLeft; break;
    }
    
    velocity = Vector2.zero();
    
    // Tembakkan bola sihir sesaat setelah animasi mulai
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isMounted) return;
      _shootMagic();
    });
    
    final ticker = animationTickers?[current];
    if (ticker != null) {
      ticker.reset();
      ticker.onComplete = () {
        isAttacking = false;
        _updateIdleState();
      };
    } else {
      isAttacking = false;
      _updateIdleState();
    }
  }

  void _shootMagic() {
    Vector2 spawnPos = position.clone();
    switch (currentDirection) {
      case PlayerDirection.up: spawnPos.y -= 25; break;
      case PlayerDirection.down: spawnPos.y += 25; break;
      case PlayerDirection.right: spawnPos.x += 25; break;
      case PlayerDirection.left: spawnPos.x -= 25; break;
    }

    final projectile = MagicProjectile(
      position: spawnPos,
      direction: currentDirection,
    );
    game.add(projectile);
  }

  void _updateIdleState() {
    switch (currentDirection) {
      case PlayerDirection.up: current = PlayerState.idleUp; break;
      case PlayerDirection.down: current = PlayerState.idleDown; break;
      case PlayerDirection.right: current = PlayerState.idleRight; break;
      case PlayerDirection.left: current = PlayerState.idleLeft; break;
    }
  }

  void _updateWalkState() {
    switch (currentDirection) {
      case PlayerDirection.up: current = PlayerState.walkUp; break;
      case PlayerDirection.down: current = PlayerState.walkDown; break;
      case PlayerDirection.right: current = PlayerState.walkRight; break;
      case PlayerDirection.left: current = PlayerState.walkLeft; break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isAttacking) {
      return;
    }

    if (joystick != null && joystick!.direction != JoystickDirection.idle) {
      velocity = joystick!.relativeDelta * speed;
      position.add(velocity * dt);
      
      if (velocity.y.abs() > velocity.x.abs()) {
        if (velocity.y > 0) {
          currentDirection = PlayerDirection.down;
        } else {
          currentDirection = PlayerDirection.up;
        }
      } else {
        if (velocity.x > 0) {
          currentDirection = PlayerDirection.right;
        } else {
          currentDirection = PlayerDirection.left;
        }
      }

      _updateWalkState();
    } else {
      velocity = Vector2.zero();
      _updateIdleState();
    }
    
    position.clamp(
      Vector2.zero() + size / 2, 
      game.mapSize - size / 2
    );
  }
}

