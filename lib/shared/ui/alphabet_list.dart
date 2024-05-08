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
  '#',
];

typedef OverlayWidgetBuilder = Widget Function(String letter);

class AlphabetList extends StatefulWidget {
  const AlphabetList({
    super.key,
    required this.child,
    required this.keywords,
    required this.onIndexChanged,
    this.alignment = LetterAlignment.right,
    this.overlayWidgetBuilder,
    this.textStyle,
    this.backgroundColor,
    this.margin,
    this.padding,
  });

  final Widget child;
  final List<String> keywords;
  final ValueChanged<int> onIndexChanged;
  final LetterAlignment alignment;
  final OverlayWidgetBuilder? overlayWidgetBuilder;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  _AlphabetListState createState() => _AlphabetListState();
}

class _AlphabetListState extends State<AlphabetList> {
  final letterKey = GlobalKey();
  final firstIndexPositions = <String, int>{};

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
      firstIndexPositions.clear();
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
      firstIndexPositions.clear();
      firstIndexPositions.addAll(
        _alphabet.asMap().map((_, value) => MapEntry(value, 0)),
      );
      return;
    }

    String? lastLetter;
    for (var letter in _alphabet) {
      final firstElement = _keywords.firstWhereOrNull((item) => item.toLowerCase().startsWith(letter));

      if (firstElement != null) {
        int index = _keywords.indexOf(firstElement);
        firstIndexPositions[letter] = index;
        lastLetter = letter;
      }
    }

    for (var letter in _alphabet.reversed) {
      if (firstIndexPositions.containsKey(letter)) {
        lastLetter = letter;
        continue;
      }

      firstIndexPositions[letter] = firstIndexPositions[lastLetter] ?? 0;
    }
  }

  void onIndexChanged(int selectedIndex, double overlayPositionY) {
    final index = firstIndexPositions[_alphabet[selectedIndex].toLowerCase()];
    if (index == null) {
      Logger.root.warning('Index is null');
      return;
    }

    widget.onIndexChanged(index);
  }

  void onVerticalDrag(Offset offset) {
    final letterHeight = letterKey.currentContext?.size?.height;
    if (letterHeight == null) {
      return;
    }

    final topOffset = (widget.padding?.top ?? 0) + (widget.margin?.top ?? 0);
    final index = (offset.dy - topOffset) ~/ letterHeight;
    if (index < 0 || index >= _alphabet.length) {
      return;
    }

    const unknownOffsetAdjustment = 6;
    final overlayPositionY = letterHeight * index + topOffset - unknownOffsetAdjustment;

    setState(() {
      _selectedIndex = index;
      _isFocused = true;
      _overlayPositionY = overlayPositionY;
    });

    onIndexChanged(index, offset.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: widget.alignment == LetterAlignment.left ? Alignment.centerLeft : Alignment.centerRight,
          child: GestureDetector(
            onVerticalDragStart: (details) => onVerticalDrag(details.localPosition),
            onVerticalDragUpdate: (details) => onVerticalDrag(details.localPosition),
            onVerticalDragEnd: (_) => setState(() => _isFocused = false),
            child: Container(
              padding: widget.padding,
              margin: widget.margin,
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
                          onIndexChanged(x, _overlayPositionY);
                        },
                        child: Container(
                          height: containerHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
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
            right: widget.alignment == LetterAlignment.right ? 24 : null,
            left: widget.alignment == LetterAlignment.left ? 24 : null,
            top: _overlayPositionY,
            child: widget.overlayWidgetBuilder!(_alphabet[_selectedIndex]),
          ),
      ],
    );
  }
}
