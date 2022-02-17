import 'package:flutter/widgets.dart';

class PageSemantics {
  final String Function(int pageIndex) indexToSemanticName;
  final String Function(int pageIndex) indexToTitle;
  final int Function(String semanticPageName) semanticNameToIndex;
  PageSemantics({required this.indexToSemanticName,required this.indexToTitle,required this.semanticNameToIndex})
}

/// Signature for a function that lazily creates a page
/// for a given page index / semantic page name
///
/// Used by [FlipBook.builder].
typedef PageBuilder =  Widget Function(BuildContext context, Size pageSize, int pageIndex, String? semanticPageName);
