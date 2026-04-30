import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class LayeredMapComponent extends PositionComponent {
  final SpriteSheet tileset;
  late final SpriteBatch spriteBatch;
  
  final int cols;
  final int rows;
  final double tileSize = 64.0;

  // Hardcoded map layout
  // 0: water
  // 1: top-left edge
  // 2: top-mid edge
  // 3: top-right edge
  // 4: mid-left edge
  // 5: center grass
  // 6: mid-right edge
  // 7: bot-left edge
  // 8: bot-mid edge
  // 9: bot-right edge
  
  late List<List<int>> mapGrid;

  LayeredMapComponent({
    required this.tileset,
    this.cols = 20,
    this.rows = 15,
  }) {
    spriteBatch = SpriteBatch(tileset.image);
    size = Vector2(cols * tileSize, rows * tileSize);
    
    _generateMap();
  }

  void _generateMap() {
    mapGrid = List.generate(rows, (y) => List.generate(cols, (x) {
      // 1 tile border of water
      if (y == 0 || y == rows - 1 || x == 0 || x == cols - 1) return 0;
      
      // Top row of island
      if (y == 1) {
        if (x == 1) return 1;
        if (x == cols - 2) return 3;
        return 2;
      }
      
      // Bottom row of island
      if (y == rows - 2) {
        if (x == 1) return 7;
        if (x == cols - 2) return 9;
        return 8;
      }
      
      // Middle rows of island
      if (x == 1) return 4;
      if (x == cols - 2) return 6;
      
      // Default to grass center
      return 5;
    }));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw solid water background
    final waterPaint = Paint()..color = const Color(0xFF3B83BD); // Nice water blue
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), waterPaint);

    spriteBatch.clear();

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final tileType = mapGrid[y][x];
        if (tileType == 0) continue; // Water already drawn

        int srcX = 0;
        int srcY = 0;

        // Map tileType to Spritesheet coordinates
        switch (tileType) {
          case 1: srcX = 0; srcY = 0; break;
          case 2: srcX = 1; srcY = 0; break;
          case 3: srcX = 2; srcY = 0; break;
          case 4: srcX = 0; srcY = 1; break;
          case 5: srcX = 1; srcY = 1; break;
          case 6: srcX = 2; srcY = 1; break;
          case 7: srcX = 0; srcY = 2; break;
          case 8: srcX = 1; srcY = 2; break;
          case 9: srcX = 2; srcY = 2; break;
        }

        spriteBatch.add(
          source: Rect.fromLTWH(srcX * tileSize, srcY * tileSize, tileSize, tileSize),
          offset: Vector2(x * tileSize, y * tileSize),
        );
      }
    }

    spriteBatch.render(canvas);
  }
}
