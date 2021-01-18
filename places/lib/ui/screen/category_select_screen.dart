import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/category.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/failed.dart';
import '../widget/loader.dart';
import '../widget/mocks.dart';
import '../widget/small_app_bar.dart';

/// Экран выбора категории.
class CategorySelectScreen extends StatelessWidget {
  const CategorySelectScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  /// Идентификатор категории.
  /// 
  /// Если передан `null`, то категория не установлена.
  final int? id;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringCategory,
      ),
      body: Loader<List<Category>>(
        load: () => Mocks.of(context).categories,
        error: (context, error) => Failed(
          error.toString(),
          onRepeat: () => Loader.of<List<Category>>(context).reload(),
        ),
        builder: (context, _, data) => ListView.builder(
          itemCount: data?.length ?? 0,
          itemBuilder: (context, index) =>
              _buildCategoryTile(context, theme, data![index]),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
          BuildContext context, MyThemeData theme, Category category) =>
      ListTile(
        title: Text(category.name),
        trailing: category.id == id
            ? SvgPicture.asset(
                Svg24.tick,
                color: theme.accentColor,
              )
            : null,
        onTap: () {
          Navigator.pop(context, category.id);
        },
      );
}
