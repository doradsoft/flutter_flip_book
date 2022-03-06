import 'package:flip_book/src/widget/page_delegate/page_delegate.dart';
import 'package:flip_book/src/widgets_ext/widgets_ext.dart';
import 'package:flutter/widgets.dart';

class PageListDelegate extends PageDelegate {
  /// The widgets to display.
  ///
  /// If this list is going to be mutated, it is usually wise to put a [Key] on
  /// each of the child widgets, so that the framework can match old
  /// configurations to new configurations and maintain the underlying render
  /// objects.
  ///
  /// Also, a [Widget] in Flutter is immutable, so directly modifying the
  /// [pages] such as `someWidget.children.add(...)` or
  /// passing a reference of the original list value to the [pages] parameter
  /// will result in incorrect behaviors. Whenever the
  /// children list is modified, a new list object should be provided.
  ///
  /// The following code corrects the problem mentioned above.
  ///
  /// ```dart
  /// class SomeWidgetState extends State<SomeWidget> {
  ///   List<Widget> _children;
  ///
  ///   void initState() {
  ///     _children = [];
  ///   }
  ///
  ///   void someHandler() {
  ///     setState(() {
  ///       // The key here allows Flutter to reuse the underlying render
  ///       // objects even if the children list is recreated.
  ///       _children.add(ChildWidget(key: UniqueKey()));
  ///     });
  ///   }
  ///
  ///   Widget build(BuildContext context) {
  ///     // Always create a new list of children as a Widget is immutable.
  ///     return PageView(children: List<Widget>.from(_children));
  ///   }
  /// }
  /// ```
  final List<Widget> pages;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  /// Defaults to true.
  final bool addAutomaticKeepAlives;
  PageListDelegate(this.pages, {this.addAutomaticKeepAlives = true}) : super(pages.length);

  @override
  Widget build(BuildContext context, Size pageSize, int index) {
    if (index < 0 || index >= pageCount) throw PageDelegate.outOfBoundaryEx;
    Widget page = pages[index];
    final Key? key = page.key != null ? SaltedValueKey(page.key!) : null;
    assert(
      // adopted from silver.dart
      // ignore: unnecessary_null_comparison
      page != null,
      "A flip book page must not contain null values, but a null value was found at index $index",
    );
    if (addAutomaticKeepAlives) {
      page = AutomaticKeepAlive(child: page);
    }
    return KeyedSubtree(key: key, child: page);
  }

  @override
  bool shouldRebuild(covariant PageListDelegate oldDelegate) {
    return pages != oldDelegate.pages;
  }
}
