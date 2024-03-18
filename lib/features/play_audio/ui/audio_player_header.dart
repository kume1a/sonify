import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/values/assets.dart';

class AudioPlayerHeader extends StatelessWidget {
  const AudioPlayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            iconSize: 28,
            icon: const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.chevron_right),
            ),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Playlist name',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Playlist',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.svgQuillList),
          ),
        ],
      ),
    );
  }
}
