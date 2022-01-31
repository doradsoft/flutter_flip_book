import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

class FlipBookToolbarItemsConfig {
  static const _defaultDirection = TextDirection.ltr;
  static Locale localeInit(Locale? locale) =>
      locale ?? Locale(intl.Intl.getCurrentLocale());

  final TextDirection direction;
  final Locale locale;

  FlipBookToolbarItemsConfig(
      {this.direction = _defaultDirection, Locale? locale})
      : locale = localeInit(locale);
}
