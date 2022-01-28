// ignore: avoid_web_libraries_in_flutter
import 'dart:html'; // during development only, for release, use:
// import 'package:flip_book/src/dummy_dart_html.dart'
//     if (dart.library.html) 'dart:html';

import 'package:flip_book/src/controller/leaf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FlipBookController extends ChangeNotifier {
  /// The page to show when first creating the [PageView].
  final int initialPage;

  bool get isFullScreen {
    if (kIsWeb) {
      return document.fullscreenElement != null;
    } else {
      // todo: support more platforms.
      return false;
    }
  }

  /// books length.
  final int totalPages;

  late final List<Leaf> leaves;

  FlipBookController({this.initialPage = 0, required this.totalPages}) {
    if (kIsWeb) {
      document.documentElement?.onFullscreenChange.listen((event) {
        // ignore: avoid_print
        print(isFullScreen);
        notifyListeners();
      });
    } else {
      // todo: support more platforms.
    }
  }

  Leaf get _currentLeaf => leaves.reduce((result, leaf) {
        if (leaf.isTurned) return leaf;
        return result;
      });

  /// Animates the position from its current value to the given value.
  ///
  /// Any active animation is canceled. If the user is currently paging, that
  /// action is canceled.
  ///
  /// The returned [Future] will complete when the animation ends, whether it
  /// completed successfully or whether it was interrupted prematurely.
  ///
  /// An animation will be interrupted whenever the user attempts to page
  /// manually, or whenever another activity is started, or whenever the
  /// animation reache an edge of the books and attempts to overscroll.
  ///
  /// The animation is indifferent to changes to the viewport or content
  /// dimensions.
  ///
  /// The duration must not be zero. To jump to a particular value without an
  /// animation, use [jumpTo].
  ///
  /// When calling [animateTo] in widget tests, `await`ing the returned
  /// [Future] may cause the test to hang and timeout. Instead, use
  /// [WidgetTester.pumpAndSettle].
  Future<void> animateTo(
    int page, {
    required Duration duration,
    required Curve curve,
  }) async {
    await Future.wait<void>(<Future<void>>[
      ...leaves
          .map((leaf) => leaf.animateTo(page, duration: duration, curve: curve))
      // for (int i = 0; i < _positions.length; i += 1)
      // _positions[i].animateTo(offset, duration: duration, curve: curve),
    ]);
  }

  Future<void> animateNext(
      {duration = const Duration(milliseconds: 800),
      curve = Curves.easeInOutQuad}) {
    return animateTo(_currentLeaf.pages.last + 1,
        duration: duration, curve: curve);
  }

  Future<void> animatePrev(
      {duration = const Duration(milliseconds: 800),
      curve = Curves.easeInOutQuad}) {
    return animateTo(_currentLeaf.pages.first - 1,
        duration: duration, curve: curve);
  }

  /// Jumps from its current value to the given value, without animation.
  /// Any active animation is canceled. If the user is currently scrolling, that
  /// action is canceled.
  ///
  void jumpTo(int page) {
    assert(page >= 0 && page < page);
    // for (final ScrollPosition position in List<ScrollPosition>.from(_positions))
    //   position.jumpTo(value);
  }

  void setVsync(TickerProvider vsync) {
    leaves = List<Leaf>.generate(
        (totalPages / 2).ceil(), (i) => Leaf(index: i, vsync: vsync));
  }

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
  }
}
