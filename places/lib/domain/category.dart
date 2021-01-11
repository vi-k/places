/// Категория места.
class Category {
  Category({
    required this.id,
    required this.name,
    this.svg,
  });

  final int id;
  final String name;
  final String? svg;
}
