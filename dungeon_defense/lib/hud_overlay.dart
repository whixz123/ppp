import 'package:flutter/material.dart';
import 'game_controller.dart';

class HudOverlay extends StatelessWidget {
  final GameController game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TOP LEFT: Player Info (Avatar + HP/SP Bars)
        Positioned(
          top: 20,
          left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange.shade700, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4, offset: const Offset(2, 2)),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              // Bars
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  _buildBar(color: Colors.green, width: 140, progress: 0.8),
                  const SizedBox(height: 6),
                  _buildBar(color: Colors.blue, width: 100, progress: 0.5),
                ],
              ),
            ],
          ),
        ),

        // TOP RIGHT: Minimap & Resources
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resource List
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade600.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.brown.shade800, width: 2),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💰 2045', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('🪵 2118', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('🪨 1195', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Minimap Circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.brown.shade800, width: 4),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/tiles/map1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Time Display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.brown.shade700,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade900, width: 2),
                ),
                child: const Text(
                  'Kamis 07:20',
                  style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // TOP CENTER: Next Map Button
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {
                game.loadNextMap();
              },
              icon: const Icon(Icons.map),
              label: const Text('Next Map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.orange.shade300, width: 2),
              ),
            ),
          ),
        ),

        // BOTTOM RIGHT: Action Buttons
        Positioned(
          bottom: 40,
          right: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Secondary Action (Inventory/Book)
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.brown.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown.shade900, width: 3),
                ),
                child: const Icon(Icons.menu_book, color: Colors.white, size: 24),
              ),
              // Primary Action (Attack Sihir)
              GestureDetector(
                onTapDown: (_) {
                  game.player.attack();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.greenAccent, width: 4),
                    boxShadow: [
                      BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 5),
                      BoxShadow(color: Colors.lightGreen.withValues(alpha: 0.3), blurRadius: 25, spreadRadius: 10),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [Colors.green.shade400, Colors.teal.shade900],
                        center: Alignment.topLeft,
                        radius: 1.5,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.greenAccent.shade100, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.auto_fix_high, color: Colors.white, size: 36),
                  ),
                ),
              ),
            ],
          ),
        ),

        // BOTTOM CENTER: Dialogue Box
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.brown.shade300.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.brown.shade700, width: 4),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4, offset: const Offset(0, 4)),
                ],
              ),
              child: const Text(
                'Kumpulkan bahan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBar({required Color color, required double width, required double progress}) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
