import 'package:flutter/widgets.dart';

// ignore: non_constant_identifier_names
Widget MultiAnimatedBuilder(
    {required Iterable<Listenable> animations,
    required TransitionBuilder builder}) {
  final animationsAsList = animations.toList();
  return AnimatedBuilder(
      animation: animationsAsList.removeLast(),
      builder: animationsAsList.isEmpty
          ? builder
          : (BuildContext context, Widget? child) => MultiAnimatedBuilder(
              animations: animationsAsList, builder: builder));
}
