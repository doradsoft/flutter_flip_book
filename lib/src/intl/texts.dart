import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FlipBookTexts {
  FlipBookTexts._privateConstructor();

  static final FlipBookTexts _instance = FlipBookTexts._privateConstructor();

  factory FlipBookTexts() {
    return _instance;
  }

  /// `fullScreen`
  static String fullScreen(Locale locale) => Intl.message(
        'fullScreen',
        locale: locale.toString(),
        name: 'fullScreen',
        desc: '',
        args: [],
      );

  /// `next`
  static String next(Locale locale) => Intl.message(
        'next',
        locale: locale.toString(),
        name: 'next',
        desc: '',
        args: [],
      );

  /// `previous`
  static String previous(Locale locale) => Intl.message(
        'previous',
        locale: locale.toString(),
        name: 'previous',
        desc: '',
        args: [],
      );
}
