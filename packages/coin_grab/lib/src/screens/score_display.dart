import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int missedItems;
  final int maxMissedItems;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.missedItems,
    required this.maxMissedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Score
          Text(
            'Score: $score',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
            ),
          ),
          const SizedBox(height: 10),
          // Missed items counter
          Text(
            'Missed: $missedItems/$maxMissedItems',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: missedItems >= maxMissedItems * 0.8 ? Colors.red : Colors.orange,
              shadows: const [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
            ),
          ),
        ],
      ),
    );
  }
}
