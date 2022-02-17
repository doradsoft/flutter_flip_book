import 'package:flutter/widgets.dart';

// ignore: non_constant_identifier_names
Widget MultiAnimatiedBuilder(
    {required Iterable<Animation> animations,
    required TransitionBuilder builder}) {
  final animationsAsList = animations.toList();
  return AnimatedBuilder(
      animation: animationsAsList.removeLast(),
      builder: animationsAsList.isEmpty
          ? builder
          : (BuildContext context, Widget? child) => MultiAnimatiedBuilder(
              animations: animationsAsList, builder: builder));
}
