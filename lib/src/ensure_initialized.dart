import 'package:flip_book/generated/intl/messages_all.dart';
import 'package:flutter/widgets.dart';

ensureInitialized(List<Locale> locales) async {
  // ignore: avoid_function_literals_in_foreach_calls
  locales.forEach((locale) => initializeMessages(locale.languageCode));
}
