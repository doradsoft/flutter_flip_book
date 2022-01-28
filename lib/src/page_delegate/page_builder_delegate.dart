import 'package:flip_book/src/page_delegate/page_delegate.dart';
import 'package:flip_book/src/widgets_ext/widgets_ext.dart';
import 'package:flutter/widgets.dart';

class PageBuilderDelegate extends PageDelegate {
  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  ///
  /// Defaults to true.
  final bool addAutomaticKeepAlives;

  /// Called to build pages.
  ///
  /// Will be called only for indices greater than or equal to zero and less
  /// than [pageCount] (if [pageCount] is non-null).
  ///
  /// Should return null if asked to build a widget with a greater index than
  /// exists.
  ///
  /// The delegate wraps the children returned by this builder in
  /// [RepaintBoundary] widgets.
  final NullableIndexedWidgetBuilder builder;

  const PageBuilderDelegate(this.builder,
      {pageCount, this.addAutomaticKeepAlives = true})
      : super(pageCount);

  @override
  @pragma('vm:notify-debugger-on-exception')
  Widget? build(BuildContext context, int index) {
    if (index < 0 || index >= pageCount) return null;
    Widget? page;
    try {
      page = builder(context, index);
    } catch (exception, stackTrace) {
      page = createErrorWidget(exception, stackTrace);
    }
    if (page == null) {
      return null;
    }
    final Key? key = page.key != null ? SaltedValueKey(page.key!) : null;
    if (addAutomaticKeepAlives) page = AutomaticKeepAlive(child: page);
    return KeyedSubtree(key: key, child: page);
  }

  @override
  bool shouldRebuild(covariant PageBuilderDelegate oldDelegate) => true;
}
