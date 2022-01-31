import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FlipBookTexts {
  FlipBookTexts._privateConstructor();

  static final FlipBookTexts _instance = FlipBookTexts._privateConstructor();

  factory FlipBookTexts() {
    return _instance;
  }
  static String next(Locale locale) => Intl.message(
        'next',
        locale: locale.toString(),
        name: 'next',
        desc: '',
        args: [],
      );
}
