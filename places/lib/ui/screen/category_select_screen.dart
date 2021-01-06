import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/category.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/failed.dart';
import '../widget/loadable_data.dart';
import '../widget/mocks.dart';
import '../widget/small_app_bar.dart';

class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  final int? id;

  @override
  _CategorySelectScreenState createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  late Future<List<Category>> categories;
  late int? id;

  @override
  void initState() {
    super.initState();

    id = widget.id;
    categories = Mocks.of(context).categories;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringCategory,
      ),
      body: LoadableData<List<Category>>(
        future: categories,
        error: (context, error) => Failed(
          error.toString(),
          onRepeat: () {
            setState(() {
              categories = Mocks.of(context).categories;
            });
          },
        ),
        builder: (context, _, data) => data == null
            ? null
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    _buildCategoryTile(theme, data[index]),
              ),
      ),
    );
  }

  Widget _buildCategoryTile(MyThemeData theme, Category category) => ListTile(
        title: Text(category.name),
        trailing: category.id == widget.id
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
