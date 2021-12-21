import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/screen/filters_screen.dart';

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
    this.debounceTime = const Duration(milliseconds: 1000),
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
  late Filter? filter = widget.filter;

  late final TextEditingController _textController =
      TextEditingController(text: widget.initialText)
        ..addListener(() {
          _textStreamController.add(_textController.text);
        });

  late final StreamController<String> _textStreamController =
      StreamController<String>()
        ..stream.debounceTime(widget.debounceTime).listen((data) async {
          widget.onTextChanged?.call(data);
        });

  late MyThemeData _theme;

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

    if (oldWidget.filter != widget.filter) {
      filter = widget.filter;
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;

    return Stack(
      children: [
        Material(
          color: _theme.backgroundSecond,
          borderRadius: BorderRadius.circular(searchFieldRadius),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              _buildTextField(),
              if (widget.onTap != null) _buildTopButton(),
              _buildSuffixButton(),
            ],
          ),
        ),
      ],
    );
  }

  Positioned _buildTopButton() => Positioned.fill(
        child: InkWell(
          onTap: widget.onTap,
        ),
      );

  Widget _buildSuffixButton() => Positioned(
        top: 0,
        bottom: 0,
        right: 4,
        child: filter == null ? _buildClearButton() : _buildFilterButton(),
      );

  SvgButton _buildClearButton() => SvgButton(
        Svg24.clear,
        color: _theme.mainTextColor,
        onPressed: _textController.clear,
      );

  Widget _buildFilterButton() => SvgButton(
        Svg24.filter,
        color:
            filter == Filter() ? _theme.lightTextColor56 : _theme.accentColor,
        onPressed: () async {
          final newFilter = await standartNavigatorPush<Filter>(
            context,
            () => FiltersScreen(filter: filter!),
          );

          if (newFilter != null) {
            filter = newFilter;
            widget.onFilterChanged?.call(newFilter);
          }
        },
      );

  Widget _buildTextField() => TextFormField(
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
              color: _theme.lightTextColor56,
            ),
          ),
          suffixIconConstraints: const BoxConstraints.tightFor(
            height: smallButtonHeight,
            width: smallButtonHeight,
          ),
          suffixIcon: const SizedBox(),
          hintText: stringSearch,
          enabledBorder:
              _theme.app.inputDecorationTheme.enabledBorder?.copyWith(
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder:
              _theme.app.inputDecorationTheme.enabledBorder?.copyWith(
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
      );
}
