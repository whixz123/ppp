import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'player_component.dart';

class MagicProjectile extends PositionComponent with CollisionCallbacks {
  final PlayerDirection direction;
  final double speed = 350.0;
  final double lifespan = 1.5; // hancur setelah 1.5 detik
  double age = 0;

  late CircleComponent core;
  late CircleComponent glow;

  MagicProjectile({
    required Vector2 position,
    required this.direction,
  }) : super(position: position, size: Vector2(24, 24), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Glow effect (Aura hijau menyala)
    glow = CircleComponent(
      radius: 16,
      paint: Paint()
        ..color = const Color(0xFF4CFF4C).withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      anchor: Anchor.center,
      position: size / 2,
    );

    // Core effect (Inti bola sihir putih/hijau terang)
    core = CircleComponent(
      radius: 8,
      paint: Paint()..color = const Color(0xFFE0FFE0),
      anchor: Anchor.center,
      position: size / 2,
    );

    add(glow);
    add(core);

    // Hitbox untuk musuh (diatur radius 10)
    add(CircleHitbox(radius: 10, position: Vector2(2, 2)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Gerakan bola sihir
    Vector2 movement = Vector2.zero();
    switch (direction) {
      case PlayerDirection.up:
        movement.y = -1;
        break;
      case PlayerDirection.down:
        movement.y = 1;
        break;
      case PlayerDirection.left:
        movement.x = -1;
        break;
      case PlayerDirection.right:
        movement.x = 1;
        break;
    }
    
    position.add(movement * speed * dt);

    // Efek berkedip/pulsing pada glow
    glow.radius = 16 + (4 * (age * 10).toInt() % 2);

    age += dt;
    if (age > lifespan) {
      removeFromParent();
    }
  }

  // Jika menabrak musuh (bisa dikembangkan nanti)
  // @override
  // void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   super.onCollisionStart(intersectionPoints, other);
  //   if (other is EnemyComponent) {
  //     // Berikan damage
  //     removeFromParent();
  //   }
  // }
}
