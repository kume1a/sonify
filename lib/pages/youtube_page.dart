import 'package:flutter/material.dart';

class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Youtube')),
    );
  }
}
