// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print
import 'dart:math';

import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/controller/leaf.dart';
import 'package:flip_book/src/page_delegate/page_builder_delegate.dart';
import 'package:flip_book/src/page_delegate/page_delegate.dart';
import 'package:flip_book/src/page_delegate/page_list_delegate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

abstract class SemanticIndexConverter {
  int pageToSemanticIndex(int page);
  int semanticIndexToPage(int semanticIndex);
}

class FlipBook extends StatefulWidget {
  static const _defaultAspectRatio = 3 / 2;
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

  final bool addAutomaticKeepAlives;

  /// The axis along which the book pages flip.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis axis;
  final double aspectRatio;
  final FlipBookController controller;
  final TextDirection direction;
  final Locale locale;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;
  final EdgeInsets padding;

  /// A delegate that provides the children for the [PageView].
  ///
  /// The [FlipBook.custom] constructor lets you specify this delegate
  /// explicitly. The [FlipBook] and [FlipBook.builder] constructors create a
  /// [pageDelegate] that wraps the given [List] and [IndexedWidgetBuilder],
  /// respectively.
  final PageDelegate pageDelegate;
  final int bufferSize;
  FlipBook({
    Key? key,
    this.addAutomaticKeepAlives = true,
    this.aspectRatio = _defaultAspectRatio,
    this.axis = _defaultAxis,
    this.bufferSize = _defaultBufferSize,
    TextDirection? direction,
    FlipBookController? controller,
    Locale? locale,
    this.onPageChanged,
    this.padding = _defaultPadding,
    List<Widget> pages = const <Widget>[],
  })  : controller = controller ?? FlipBookController(totalPages: pages.length),
        locale = localeInit(locale),
        direction = directionInit(direction, locale),
        pageDelegate = PageListDelegate(
          pages,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
        ),
        super(key: key);
  FlipBook.builder({
    Key? key,
    this.addAutomaticKeepAlives = true,
    this.aspectRatio = _defaultAspectRatio,
    this.axis = _defaultAxis,
    this.bufferSize = _defaultBufferSize,
    TextDirection? direction,
    FlipBookController? controller,
    Locale? locale,
    this.onPageChanged,
    required IndexedWidgetBuilder itemBuilder,
    this.padding = _defaultPadding,
    required int totalPages,
  })  : assert(totalPages >= 4),
        controller = controller ?? FlipBookController(totalPages: totalPages),
        locale = localeInit(locale),
        direction = directionInit(direction, locale),
        pageDelegate = PageBuilderDelegate(
          itemBuilder,
          pageCount: totalPages,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
        ),
        super(key: key);

  @override
  FlipBookState createState() => FlipBookState();
}

class FlipBookState extends State<FlipBook> with TickerProviderStateMixin {
  late double _startingPos;
  int currentLeaf = 0;
  int turningLeaf = 0;
  late FlipBookController controller;
  Size _bgSize = const Size(0, 0);
  Size _leafSize = const Size(0, 0);
  double _globalDelta = 0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.setVsync(this);
  }

  @override
  void didChangeDependencies() {
    _bgSize = MediaQuery.of(context).size;
    _leafSize = Size((_bgSize.width - widget.padding.horizontal) / 2,
        _bgSize.height - widget.padding.vertical);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Directionality(
      textDirection: widget.direction,
      child: Material(
        child: GestureDetector(
          onHorizontalDragStart: _onDragStart,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(color: const Color(0xff515151)),
              Stack(
                  children: controller.leaves
                      .map((leaf) => Positioned.fill(
                          top: widget.padding.top,
                          bottom: widget.padding.bottom,
                          left: widget.padding.left,
                          right: _leafSize.width + widget.padding.right,
                          child: AnimatedBuilder(
                              animation: leaf.animation,
                              builder: (context, animatedBuilderWidget) =>
                                  _animationBuilder(
                                      context, animatedBuilderWidget, leaf))))
                      .toList())
            ],
          ),
        ),
      ),
    );
  }

  _animationBuilder(context, animationBuilderWidget, Leaf leaf) {
    final animation = leaf.animation;
    final pageMaterial = Align(
      alignment: Alignment.centerLeft,
      child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Positioned(
            right: 0,
            child: Container(
              height: _leafSize.height,
              width: _leafSize.width,
              color: Color(leaf.index == 0 ? 0xffaaffff : 0xffc1f0db),
            ),
          )),
    );
    return Transform.translate(
      offset: Offset(_leafSize.width, 0),
      child: Transform(
        transform: Matrix4.identity()..rotateY(pi),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY((pi) * animation.value),
          alignment: Alignment.centerLeft,
          child: pageMaterial,
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    _startingPos = details.globalPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _globalDelta = details.globalPosition.dx - _startingPos;
    if (_globalDelta > 0) {
      // forward
      final pos = _globalDelta / _bgSize.width;
      if (currentLeaf == controller.leaves.length) {
        return;
      }
      turningLeaf = currentLeaf;
      controller.leaves[currentLeaf].animationController.value = pos;
    } else {
      // reverse
      final pos = 1 - (_globalDelta.abs() / _bgSize.width);
      if (currentLeaf == 0) {
        return;
      }
      turningLeaf = _globalDelta > 0
          ? currentLeaf
          : (currentLeaf > 0 ? currentLeaf - 1 : 0);
      controller.leaves[turningLeaf].animationController.value = pos;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (currentLeaf != controller.leaves.length &&
        ((details.velocity.pixelsPerSecond.dx.abs() > 500 &&
                details.velocity.pixelsPerSecond.dx > 0) ||
            controller.leaves[currentLeaf].animationController.value > 0.5)) {
      controller.leaves[currentLeaf].animationController.forward(
          from: controller.leaves[currentLeaf].animationController.value);
      setState(() {
        currentLeaf++;
      });
    } else {
      if (details.velocity.pixelsPerSecond.dx.abs() > 500 &&
              details.velocity.pixelsPerSecond.dx <= 0 ||
          controller.leaves[turningLeaf].animationController.value <= 0.5) {
        controller.leaves[turningLeaf].animationController.reverse(
            from: controller.leaves[turningLeaf].animationController.value);
        if (turningLeaf == currentLeaf - 1) {
          setState(() {
            currentLeaf--;
          });
        }
      } else {
        controller.leaves[turningLeaf].animationController.forward(
            from: controller.leaves[turningLeaf].animationController.value);
      }
    }
  }
}

// void _toggleDrawer() {
//   if (_animationController.value < 0.5) {
//     _animationController.forward();
//   } else {
//     _animationController.reverse();
//   }
// }
