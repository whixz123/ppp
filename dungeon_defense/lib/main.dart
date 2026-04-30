import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import 'game_controller.dart';
import 'hud_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force landscape mode for game
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Fullscreen mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final game = GameController();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'HudOverlay': (BuildContext context, GameController game) {
              return HudOverlay(game: game);
            },
          },
          initialActiveOverlays: const ['HudOverlay'],
        ),
      ),
    ),
  );
}
