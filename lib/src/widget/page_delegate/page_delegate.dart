import 'package:flutter/widgets.dart';

abstract class PageDelegate {
  /// The total number of children this delegate can provide.
  final int pageCount;

  const PageDelegate(this.pageCount) : assert(pageCount >= 4);

  /// Returns the child with the given index.
  ///
  /// Should return null if asked to build a widget with a greater
  /// index than exists. If this returns null, [estimatedChildCount]
  /// must subsequently return a precise non-null value (which is then
  /// used to implement [RenderSliverBoxChildManager.childCount]).
  ///
  /// Subclasses typically override this function and wrap their children in
  /// [AutomaticKeepAlive], [IndexedSemantics], and [RepaintBoundary] widgets.
  ///
  /// The values returned by this method are cached. To indicate that the
  /// widgets have changed, a new delegate must be provided, and the new
  /// delegate's [shouldRebuild] method must return true.
  Widget? build(BuildContext context, int index);

  /// Called at the end of layout to indicate that layout is now complete.
  ///
  /// The `firstIndex` argument is the index of the first child that was
  /// included in the current layout. The `lastIndex` argument is the index of
  /// the last child that was included in the current layout.
  ///
  /// Useful for subclasses that which to track which children are included in
  /// the underlying render tree.
  void didFinishLayout(int firstIndex, int lastIndex) {}

  /// Called whenever a new instance of the child delegate class is
  /// provided.
  ///
  /// If the new instance represents different information than the old
  /// instance, then the method should return true, otherwise it should return
  /// false.
  ///
  /// If the method returns false, then the [build] call might be optimized
  /// away.
  bool shouldRebuild(covariant PageDelegate oldDelegate);
}
