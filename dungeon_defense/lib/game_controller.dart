import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/experimental.dart';

import 'package:flame/sprite.dart';
import 'player_component.dart';
import 'layered_map_component.dart';

class GameController extends FlameGame with HasCollisionDetection, DragCallbacks {
  late PlayerComponent player;
  late JoystickComponent joystick;
  
  LayeredMapComponent? currentMapComponent;
  int currentMapIndex = 1;

  // Map boundaries
  Vector2 mapSize = Vector2.zero();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Setup Joystick
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 40),
    );

    // Setup Player
    player = PlayerComponent(joystick: joystick);

    // Load initial map
    await loadMap(1);

    // Add player to world after map
    world.add(player);
    
    camera.viewport.add(joystick);
    camera.follow(player);
  }

  Future<void> loadMap(int index) async {
    if (currentMapComponent != null) {
      currentMapComponent!.removeFromParent();
    }

    currentMapIndex = index;
    // Map 1 uses green tilemap, Map 2 uses sand tilemap (if we had it, but we only have color1 and color2)
    final colorSuffix = index == 1 ? '1' : '2';
    final tilesetImage = await images.load('terrain/Tilemap_color$colorSuffix.png');
    final tileset = SpriteSheet(image: tilesetImage, srcSize: Vector2.all(64));
    
    currentMapComponent = LayeredMapComponent(
      tileset: tileset,
      cols: 20, // 1280 px wide
      rows: 15, // 960 px high
    );
    
    currentMapComponent!.position = Vector2.zero();
    world.add(currentMapComponent!);
    
    mapSize = currentMapComponent!.size;

    camera.setBounds(
      Rectangle.fromLTWH(0, 0, mapSize.x, mapSize.y),
    );

    // Provide player bounds
    player.position = mapSize / 2;
  }

  void loadNextMap() {
    int nextIndex = currentMapIndex == 1 ? 2 : 1;
    loadMap(nextIndex);
  }
}
