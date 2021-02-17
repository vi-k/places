import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';

import 'package:places/data/repository/base/filter.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/filters_screen.dart';
import 'package:places/utils/let_and_also.dart';

import 'svg_button.dart';

/// Поле поиска.
class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.onTap,
    this.filter,
    this.onFilterChanged,
    String? initialText,
    this.onTextChanged,
    this.debounceTime = const Duration(seconds: 1),
  })  : assert(filter != null && onFilterChanged != null ||
            initialText != null && onTextChanged != null),
        initialText = initialText ?? '',
        super(key: key);

  /// Обратный вызов при нажатии на поле.
  ///
  /// Если не `null`, поле становится недоступно для ввода, на него только
  /// можно нажать.
  final void Function()? onTap;

  /// Фильтр.
  final Filter? filter;

  /// Обратный вызов при изменении фильтра.
  final void Function(Filter filter)? onFilterChanged;

  final String initialText;

  /// Обратный вызов при изменении текста.
  final void Function(String text)? onTextChanged;

  /// debounce time
  final Duration debounceTime;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Filter? filter;
  final _textController = TextEditingController();
  final _textStreamController = StreamController<String>();

  @override
  void initState() {
    super.initState();

    filter = widget.filter;
    _textController
      ..text = widget.initialText
      ..addListener(() {
        _textStreamController.add(_textController.text);
      });

    _textStreamController.stream
        .debounceTime(widget.debounceTime)
        .listen((data) async {
      widget.onTextChanged?.call(data);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textStreamController.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialText != widget.initialText) {
      _textController.value = TextEditingValue(
        text: widget.initialText,
        selection: TextSelection.collapsed(offset: widget.initialText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Stack(
      children: [
        Material(
          color: theme.backgroundSecond,
          borderRadius: BorderRadius.circular(searchFieldRadius),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              TextFormField(
                controller: _textController,
                autofocus: true,
                readOnly: widget.onTap != null,
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints.tightFor(
                    height: smallButtonHeight,
                    width: smallButtonHeight,
                  ),
                  prefixIcon: UnconstrainedBox(
                    child: SvgPicture.asset(
                      Svg24.search,
                      color: theme.lightTextColor56,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints.tightFor(
                    height: smallButtonHeight,
                    width: smallButtonHeight,
                  ),
                  suffixIcon: const SizedBox(),
                  hintText: stringSearch,
                  enabledBorder: theme.app.inputDecorationTheme.enabledBorder
                      ?.copyWith(
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                  focusedBorder: theme.app.inputDecorationTheme.enabledBorder
                      ?.copyWith(
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                ),
              ),
              if (widget.onTap != null)
                Positioned.fill(
                  child: InkWell(
                    onTap: widget.onTap,
                  ),
                ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 4,
                child: filter?.let((it) => SvgButton(
                          Svg24.filter,
                          color: theme.accentColor,
                          onPressed: () async {
                            final newFilter = await Navigator.push<Filter>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FiltersScreen(filter: it),
                              ),
                            );

                            newFilter?.also((it) {
                              filter = newFilter;
                              widget.onFilterChanged?.call(newFilter);
                            });
                          },
                        )) ??
                    SvgButton(
                      Svg24.clear,
                      color: theme.mainTextColor,
                      onPressed: _textController.clear,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
