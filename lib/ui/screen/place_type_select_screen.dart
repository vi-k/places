import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/widget/small_app_bar.dart';

/// Экран выбора типа места.
class PlaceTypeSelectScreen extends StatelessWidget {
  const PlaceTypeSelectScreen({
    Key? key,
    this.placeType,
  }) : super(key: key);

  /// Идентификатор типа.
  ///
  /// Если передан `null`, то тип места не установлен.
  final PlaceType? placeType;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringPlaceType,
      ),
      body: ListView.builder(
        itemCount: PlaceType.values.length,
        itemBuilder: (context, index) {
          final tilePlaceType = PlaceTypeUi(PlaceType.values[index]);

          return ListTile(
            title: Text(tilePlaceType.name),
            trailing: tilePlaceType.type == placeType
                ? SvgPicture.asset(
                    Svg24.tick,
                    color: theme.accentColor,
                  )
                : null,
            onTap: () => Navigator.pop(context, tilePlaceType.type),
          );
        },
      ),
    );
  }
}
