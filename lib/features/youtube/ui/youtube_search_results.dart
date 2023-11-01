import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';

import '../../../shared/values/assets.dart';
import '../state/youtube_search_state.dart';

class YoutubeSearchResults extends StatelessWidget {
  const YoutubeSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeSearchCubit, YoutubeSearchState>(
      builder: (_, state) {
        return state.maybeWhen(
          success: (data) => _SuggestionList(data),
          loading: () => const Center(child: CircularProgressIndicator()),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList(this.data);

  final List<String> data;

  @override
  Widget build(BuildContext context) {
    Logger.root.info(data);

    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svgHistory,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                data[index],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
