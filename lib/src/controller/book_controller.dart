// ignore: avoid_web_libraries_in_flutter
// import 'dart:html'; // during development only, for release, use:
import 'package:flip_book/src/dummy_dart_html.dart' if (dart.library.html) 'dart:html';

import 'package:flip_book/src/controller/leaf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

/// [FlipBook]'s controller
class FlipBookController extends ChangeNotifier {
  /// The page to show when first creating the [PageView].
  bool animating = false;
  final int initialPage;
  late List<Leaf> leaves = [];
  // List<Leaf> get reversedLeaves {
  //   return leaves.reversed.where((leaf) => leaf.animationController.value < 0.5).toList();
  // }

  // List<Leaf> get straightLeaves {
  //   return leaves.where((leaf) => leaf.animationController.value >= 0.5).toList();
  // }

  /// books length.
  final int totalPages;
  bool isFullScreen = false;

  /// [FlipBookController]'s constructor
  ///
  /// The [initialPage] defines the page to show at the first time
  /// The [totalPages] defines the amount of pages in the book
  FlipBookController({this.initialPage = 0, required this.totalPages}) {
    if (kIsWeb) {
      document.documentElement?.onFullscreenChange.listen((event) {
        if (document.fullscreenElement == null) {
          isFullScreen = false;
          notifyListeners();
        }
      });
    } else {
      // todo: support more platforms.
    }
  }

  Tuple2<Leaf?, Leaf?> get currentLeaves {
    int secondLeafIndex = -1;
    for (var i = leaves.length - 1; i >= 0; i--) {
      Leaf leaf = leaves[i];
      if (leaf.isTurned) {
        secondLeafIndex = leaf.index + 1;
        break;
      }
    }

    return secondLeafIndex == -1
        ? Tuple2(null, leaves[0])
        : secondLeafIndex == leaves.length
            ? Tuple2(leaves[secondLeafIndex - 1], null)
            : Tuple2(leaves[secondLeafIndex - 1], leaves[secondLeafIndex]);
  }

  Tuple2<Leaf?, Leaf?> get currentOrTurningLeaves {
    int secondLeafIndex = -1;
    for (var i = leaves.length - 1; i >= 0; i--) {
      Leaf leaf = leaves[i];
      if (leaf.isTurned || leaf.isTurning) {
        secondLeafIndex = leaf.index + 1;
        break;
      }
    }

    return secondLeafIndex == -1
        ? Tuple2(null, leaves[0])
        : secondLeafIndex == leaves.length
            ? Tuple2(leaves[secondLeafIndex - 1], null)
            : Tuple2(leaves[secondLeafIndex - 1], leaves[secondLeafIndex]);
  }

  Leaf get currentLeaf => currentLeaves.toList().lastWhere((leaf) => leaf != null);

  bool get isClosed => currentOrTurningLeaves.item1 == null;
  bool get isClosedInverted => currentLeaves.item2 == null;

  /// Animates current leaf forward
  Future<void> animateNext({duration = const Duration(milliseconds: 800), curve = Curves.easeInOutQuad}) async {
    if (animating || currentLeaves.item2 == null) return Future.value();
    return await animateTo(currentLeaves.item2!.pages.last + 1, duration: duration, curve: curve);
  }

  /// Animates current leaf backward
  Future<void> animatePrev({duration = const Duration(milliseconds: 800), curve = Curves.easeInOutQuad}) async {
    if (animating || currentLeaves.item1 == null) return Future.value();
    return await animateTo(currentLeaves.item1!.pages.first - 2, duration: duration, curve: curve);
  }

  /// Animates the position from its current page to the given page.
  ///
  /// The returned [Future] will complete when the animation ends, whether it
  /// completed successfully or whether it was interrupted prematurely.
  ///
  /// The duration must not be zero. To jump to a particular value without an
  /// animation, use [jumpTo].
  ///
  /// When calling [animateTo] in widget tests, `await`ing the returned
  /// [Future] may cause the test to hang and timeout. Instead, use WidgetTester.pumpAndSettle.
  Future<void> animateTo(
    int page, {
    required Duration duration,
    required Curve curve,
  }) async {
    animating = true;
    await Future.wait<void>(<Future<void>>[
      ...leaves.map((leaf) => leaf.animateTo(page, duration: duration, curve: curve))
      // for (int i = 0; i < _positions.length; i += 1)
      // _positions[i].animateTo(offset, duration: duration, curve: curve),
    ]);
    animating = false;
  }

  /// Jumps from its current page to a given page, without animation.
  void jumpTo(int page) {
    assert(page >= 0 && page < page);
    // for (final ScrollPosition position in List<ScrollPosition>.from(_positions))
    //   position.jumpTo(value);
  }

  void setVsync(TickerProvider vsync) {
    if (leaves.isEmpty) {
      leaves = List<Leaf>.generate((totalPages / 2).ceil(), (i) => Leaf(index: i, vsync: vsync));
    } else {
      // leaves.forEach((leaf) {leaf.vs});
    }
  }

  /// shows the book in fullscreen / exiting full screen
  void toggleFullScreen() {
    if (kIsWeb) {
      if (isFullScreen) {
        document.exitFullscreen();
      } else {
        document.documentElement?.requestFullscreen();
      }
    } else {
      // todo: support more platforms.
    }
    isFullScreen = !isFullScreen;
    notifyListeners();
  }
}
