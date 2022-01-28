import 'package:flutter/widgets.dart';

class FlipBookToolbarItemsConfig {
  static const _defaultDirection = TextDirection.ltr;

  final TextDirection direction;
  FlipBookToolbarItemsConfig({this.direction = _defaultDirection});
}
