String nameFromEnum(Object value) {
  final str = value.toString();
  return str.substring(str.indexOf('.') + 1);
}
