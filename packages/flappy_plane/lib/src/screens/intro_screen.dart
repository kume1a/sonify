import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  final VoidCallback onStart;

  const IntroScreen({super.key, required this.onStart});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _audioPlayed = false;

  @override
  void initState() {
    super.initState();
    _playIntroAudio();
  }

  void _playIntroAudio() async {
    if (!_audioPlayed) {
      try {
        FlameAudio.audioCache.prefix = 'packages/flappy_plane/lib/assets/sound/';
        await FlameAudio.play('triple_alahuakbar.mp3');
        _audioPlayed = true;
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: InkWell(
        onTap: widget.onStart,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF001122), Color(0xFF003366), Color(0xFF001122)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Text(
                  'Flappy Plane',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2))],
                  ),
                ),
              ),

              const Spacer(),

              // Osama image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'packages/flappy_plane/lib/assets/images/osama.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: const Icon(Icons.error, color: Colors.white, size: 50),
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Caption
              const Text(
                '9/11 Edition',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1))],
                ),
              ),

              const SizedBox(height: 20),

              // Start instruction
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                child: const Text(
                  'Tap to Start',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1))],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
