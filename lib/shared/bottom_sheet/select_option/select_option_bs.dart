import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/intl/app_localizations.dart';
import '../../typedefs.dart';
import '../../util/color.dart';
import '../../values/app_theme_extension.dart';
import 'select_option.dart';

class SelectOptionSelectorBS<T extends Object?> extends StatelessWidget {
  const SelectOptionSelectorBS({
    super.key,
    required this.header,
    required this.options,
  });

  final LocalizedStringResolver header;
  final List<SelectOption<T>> options;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Material(
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * .6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  header(l),
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.appThemeExtension?.elSecondary,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (_, int index) {
                    final SelectOption<T> option = options[index];

                    return InkWell(
                      onTap: () => Navigator.of(context).maybePop(option.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            if (option.iconAssetName != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: SvgPicture.asset(
                                  option.iconAssetName!,
                                  width: 16,
                                  height: 16,
                                  colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                option.label(l),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
