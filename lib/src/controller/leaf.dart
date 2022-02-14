import 'package:flutter/cupertino.dart';

class Leaf extends ChangeNotifier {
  late final AnimationController animationController;
  late final CurvedAnimation animation;
  final int index;
  late final List<int> pages;
  bool get isTurned => animationController.value == 1;

  Leaf({required this.index, required TickerProvider vsync}) : super() {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutQuad,
      reverseCurve: Curves.easeInQuad,
    );

    pages = [index * 2, index * 2 + 1];
  }

  Future<void> animateTo(
    int page, {
    required Duration duration,
    required Curve curve,
  }) async {
    if (isTurned) {
      if (page < pages.first) {
        return animationController.reverse();
      }
    } else {
      if (page > pages.last) {
        return animationController.forward();
      }
    }
  }
}
