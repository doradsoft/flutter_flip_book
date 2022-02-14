import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FlipBookTexts {
  FlipBookTexts._privateConstructor();

  static final FlipBookTexts _instance = FlipBookTexts._privateConstructor();

  factory FlipBookTexts() {
    return _instance;
  }

  /// `audio`
  static String audio(Locale locale) => Intl.message(
        'audio',
        locale: locale.toString(),
        name: 'audio',
        desc: '',
        args: [],
      );

  /// `cover`
  static String cover(Locale locale) => Intl.message(
        'cover',
        locale: locale.toString(),
        name: 'cover',
        desc: '',
        args: [],
      );

  /// `fullScreen`
  static String fullScreen(Locale locale) => Intl.message(
        'full screen',
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

  /// `page number`
  static String pageNumber(Locale locale) => Intl.message(
        'page number',
        locale: locale.toString(),
        name: 'pageNumber',
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

  /// `table of contents`
  static String tableOfContents(Locale locale) => Intl.message(
        'table of contents',
        locale: locale.toString(),
        name: 'tableOfContents',
        desc: '',
        args: [],
      );
}
