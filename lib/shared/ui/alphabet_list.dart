import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../util/equality.dart';

enum LetterAlignment { left, right }

const List<String> _alphabet = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
];

typedef OverlayWidgetBuilder = Widget Function(String letter);

class AlphabetList extends StatefulWidget {
  const AlphabetList({
    super.key,
    required this.child,
    required this.keywords,
    required this.onIndexChanged,
    this.alignment = LetterAlignment.right,
    this.itemExtent = 40,
    this.overlayWidgetBuilder,
    this.textStyle,
    this.backgroundColor,
  });

  final Widget child;
  final List<String> keywords;
  final ValueChanged<int> onIndexChanged;
  final LetterAlignment alignment;
  final double itemExtent;
  final OverlayWidgetBuilder? overlayWidgetBuilder;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  _AlphabetListState createState() => _AlphabetListState();
}

class _AlphabetListState extends State<AlphabetList> {
  final key = GlobalKey();
  final letterKey = GlobalKey();
  final firstIndexPosition = <String, int>{};

  int _selectedIndex = 0;
  double _overlayPositionY = 0;
  List<String> _keywords = [];
  bool _isFocused = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AlphabetList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (notDeepEquals(oldWidget.keywords, widget.keywords)) {
      _keywords.clear();
      firstIndexPosition.clear();
      _init();
    }
  }

  void _init() {
    widget.keywords.sort((x, y) => x.toLowerCase().compareTo(y.toLowerCase()));
    _keywords = widget.keywords;

    calculateFirstIndex();
    setState(() {});
  }

  void calculateFirstIndex() {
    if (_keywords.isEmpty) {
      firstIndexPosition.clear();
      firstIndexPosition.addAll(
        _alphabet.asMap().map((_, value) => MapEntry(value, 0)),
      );
      return;
    }

    String? lastLetter;
    for (var letter in _alphabet) {
      final firstElement = _keywords.firstWhereOrNull((item) => item.toLowerCase().startsWith(letter));

      if (firstElement != null) {
        int index = _keywords.indexOf(firstElement);
        firstIndexPosition[letter] = index;
        lastLetter = letter;
      }
    }

    for (var letter in _alphabet.reversed) {
      if (firstIndexPosition.containsKey(letter)) {
        lastLetter = letter;
        continue;
      }

      firstIndexPosition[letter] = firstIndexPosition[lastLetter] ?? 0;
    }
  }

  void scrolltoIndex(int x, double overlayPositionY) {
    final index = firstIndexPosition[_alphabet[x].toLowerCase()];
    if (index == null) {
      Logger.root.warning('Index is null');
      return;
    }

    setState(() {
      _overlayPositionY = letterKey.currentContext!.size!.height * _selectedIndex;
    });
  }

  void onVerticalDrag(Offset offset) {
    final alphabetHeight = letterKey.currentContext?.size?.height;
    if (alphabetHeight == null) {
      return;
    }

    final index = offset.dy ~/ alphabetHeight;
    if (index < 0 || index >= _alphabet.length) {
      return;
    }

    setState(() {
      _selectedIndex = index;
      _isFocused = true;
    });
    scrolltoIndex(index, offset.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: widget.alignment == LetterAlignment.left ? Alignment.centerLeft : Alignment.centerRight,
          child: GestureDetector(
            onVerticalDragStart: (z) => onVerticalDrag(z.localPosition),
            onVerticalDragUpdate: (z) => onVerticalDrag(z.localPosition),
            onVerticalDragEnd: (_) => setState(() => _isFocused = false),
            child: Container(
              key: key,
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  final containerHeight = constraints.maxHeight / _alphabet.length;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _alphabet.length,
                      (x) => GestureDetector(
                        key: x == _selectedIndex ? letterKey : null,
                        onTap: () {
                          setState(() => _selectedIndex = x);
                          scrolltoIndex(x, _overlayPositionY);
                        },
                        child: Container(
                          height: containerHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: FittedBox(
                            child: Text(
                              _alphabet[x].toUpperCase(),
                              style: widget.textStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (_isFocused && widget.overlayWidgetBuilder != null)
          Positioned(
            right: widget.alignment == LetterAlignment.right ? 32 : null,
            left: widget.alignment == LetterAlignment.left ? 32 : null,
            top: _overlayPositionY + 8,
            child: widget.overlayWidgetBuilder!(_alphabet[_selectedIndex]),
          ),
      ],
    );
  }
}
