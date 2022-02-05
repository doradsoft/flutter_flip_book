import 'package:flutter/widgets.dart';

mixin PageSemantics {
  String indexToSemanticName(int pageIndex);
  String indexToTitle(int pageIndex);
  int semanticNameToIndex(String semanticPageName);
}

/// Signature for a function that lazily creates a page
/// for a given page index / semantic page name
///
/// Used by [FlipBookPage.builder].
typedef PageBuilder = Widget Function(
    BuildContext context, int pageIndex, String? semanticPageName);
