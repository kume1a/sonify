import 'package:flutter/material.dart';

import '../../../shared/ui/default_back_button.dart';

class YoutubeSearchBar extends StatelessWidget {
  const YoutubeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        DefaultBackButton(),
        SizedBox(width: 6),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search',
          ),
        ),
      ],
    );
  }
}
