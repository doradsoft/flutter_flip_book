import 'package:flip_book/src/widget/page_builder.dart';
import 'package:flip_book/src/widget/page_delegate/page_delegate.dart';
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
  final PageBuilder builder;

  final PageSemantics? pageSemantics;

  const PageBuilderDelegate(this.builder, this.pageSemantics,
      {pageCount, this.addAutomaticKeepAlives = true})
      : super(pageCount);

  @override
  @pragma('vm:notify-debugger-on-exception')
  Widget? build(BuildContext context, int index) {
    if (index < 0 || index >= pageCount) return null;
    Widget? page;
    try {
      page = builder(context, index, pageSemantics?.indexToSemanticName(index));
    } catch (exception, stackTrace) {
      page = createErrorWidget(exception, stackTrace);
    }
    final Key? key = page.key != null ? SaltedValueKey(page.key!) : null;
    if (addAutomaticKeepAlives) page = AutomaticKeepAlive(child: page);
    return KeyedSubtree(key: key, child: page);
  }

  @override
  bool shouldRebuild(covariant PageBuilderDelegate oldDelegate) => true;
}
