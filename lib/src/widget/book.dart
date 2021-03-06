// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flip_book/src/aspect_ratio_fraction.dart';
import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/widget/book_state.dart';
import 'package:flip_book/src/widget/page_builder.dart';
import 'package:flip_book/src/widget/page_delegate/page_builder_delegate.dart';
import 'package:flip_book/src/widget/page_delegate/page_delegate.dart';
import 'package:flip_book/src/widget/page_delegate/page_list_delegate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FlipBook extends StatefulWidget {
  static const _defaultLeafAspectRatio = AspectRatioFraction(2, 3);
  static const _defaultCoverAspectRatio = AspectRatioFraction(2.15, 3.15);
  static const _defaultAxis = Axis.horizontal;
  static const _defaultBufferSize = 2;
  static const _defaultPadding = EdgeInsets.all(10);

  static Locale localeInit(Locale? locale) =>
      locale ?? Locale(intl.Intl.getCurrentLocale());
  static TextDirection directionInit(
          TextDirection? direction, Locale? locale) =>
      direction ??
      (intl.Bidi.isRtlLanguage(localeInit(locale).languageCode)
          ? TextDirection.rtl
          : TextDirection.ltr);
  static bool aspectRatioValidation(AspectRatioFraction coverAspectRatio,
          AspectRatioFraction leafAspectRatio) =>
      coverAspectRatio.heightFactor != 0 &&
      coverAspectRatio.widthFactor != 0 &&
      leafAspectRatio.heightFactor != 0 &&
      leafAspectRatio.widthFactor != 0 &&
      coverAspectRatio.widthFactor >= leafAspectRatio.widthFactor &&
      coverAspectRatio.heightFactor >= leafAspectRatio.heightFactor;
  static bool totalPagesValidation(int? totalPages) =>
      totalPages != null && totalPages >= 4 && totalPages % 2 == 0;
  final bool addAutomaticKeepAlives;

  /// The axis along which the book pages flip.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis axis;
  final FlipBookController controller;
  final AspectRatioFraction coverAspectRatio;
  final TextDirection direction;
  final AspectRatioFraction leafAspectRatio;
  final Locale locale;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;
  final EdgeInsets padding;
  final PageSemantics? pageSemantics;

  /// A delegate that provides the children for the [FlipBook].
  ///
  /// The [FlipBook] and [FlipBook.builder] constructors create a
  /// [pageDelegate] that wraps the given [List] and [IndexedWidgetBuilder],
  /// respectively.
  /// in the future: FlipBook.custom constructor will let you specify this delegate
  /// explicitly.
  final PageDelegate pageDelegate;
  final int bufferSize;
  FlipBook({
    Key? key,
    this.addAutomaticKeepAlives = false,
    this.axis = _defaultAxis,
    this.bufferSize = _defaultBufferSize,
    FlipBookController? controller,
    this.coverAspectRatio = _defaultCoverAspectRatio,
    TextDirection? direction,
    this.leafAspectRatio = _defaultLeafAspectRatio,
    Locale? locale,
    this.onPageChanged,
    this.padding = _defaultPadding,
    this.pageSemantics,
    List<Widget> pages = const <Widget>[],
  })  : assert(aspectRatioValidation(coverAspectRatio, leafAspectRatio)),
        controller = controller ?? FlipBookController(totalPages: pages.length),
        locale = localeInit(locale),
        direction = directionInit(direction, locale),
        pageDelegate = PageListDelegate(
          pages,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
        ),
        super(key: key);
  FlipBook.builder({
    Key? key,
    this.addAutomaticKeepAlives = false,
    this.axis = _defaultAxis,
    this.bufferSize = _defaultBufferSize,
    FlipBookController? controller,
    this.coverAspectRatio = _defaultCoverAspectRatio,
    TextDirection? direction,
    this.leafAspectRatio = _defaultLeafAspectRatio,
    Locale? locale,
    this.onPageChanged,
    this.padding = _defaultPadding,
    required PageBuilder pageBuilder,
    this.pageSemantics,
    int? totalPages,
  })  : assert(totalPagesValidation(controller?.totalPages) ||
            totalPagesValidation(totalPages)),
        assert(aspectRatioValidation(coverAspectRatio, leafAspectRatio)),
        controller = controller ?? FlipBookController(totalPages: totalPages!),
        locale = localeInit(locale),
        direction = directionInit(direction, locale),
        pageDelegate = PageBuilderDelegate(
          pageBuilder,
          pageSemantics,
          pageCount: totalPages ?? controller!.totalPages,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
        ),
        super(key: key);

  @override
  FlipBookState createState() => FlipBookState();
}
