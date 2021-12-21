extension Let<T extends Object> on T {
  R let<R>(R Function(T it) op) => op(this);

  T also(void Function(T it) op) {
    op(this);

    return this;
  }
}
