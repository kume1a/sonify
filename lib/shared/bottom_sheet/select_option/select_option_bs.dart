import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/color.dart';
import '../../values/app_theme_extension.dart';
import 'select_option.dart';

class SelectOptionSelectorBS<T extends Object?> extends StatelessWidget {
  const SelectOptionSelectorBS({
    super.key,
    required this.header,
    required this.options,
  });

  final String header;
  final List<SelectOption<T>> options;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);

    return Material(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: mediaQueryData.size.height * .6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                header,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.appThemeExtension?.elSecondary,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
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
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            option.iconAssetName,
                            width: 16,
                            height: 16,
                            colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              option.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
    );
  }
}
