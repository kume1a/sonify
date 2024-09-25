import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/intl/app_localizations.dart';
import '../values/assets.dart';

class SearchInputWithCancel extends StatelessWidget {
  const SearchInputWithCancel({
    super.key,
    required this.onChanged,
    required this.onCancelPressed,
    this.onSubmitted,
    this.controller,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onCancelPressed;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            autocorrect: false,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: l.search,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 6),
                child: SvgPicture.asset(Assets.svgSearch),
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(width: 32, height: 24),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
        const SizedBox(width: 20),
        MaterialButton(
          onPressed: onCancelPressed,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 32,
          minWidth: 10,
          child: Text(
            l.cancel,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
