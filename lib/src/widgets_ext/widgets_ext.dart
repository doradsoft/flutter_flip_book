import 'package:flutter/widgets.dart';

Widget createErrorWidget(Object exception, StackTrace stackTrace) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stackTrace,
    library: 'widgets library',
    context: ErrorDescription('building'),
  );
  FlutterError.reportError(details);
  return ErrorWidget.builder(details);
}

class SaltedValueKey extends ValueKey<Key> {
  // adopted from silver.dart
  const SaltedValueKey(Key key)
      // ignore: unnecessary_null_comparison
      : assert(key != null),
        super(key);
}
