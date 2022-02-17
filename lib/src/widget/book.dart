// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print
import 'dart:math';

import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/controller/leaf.dart';
import 'package:flip_book/src/widget/page_builder.dart';
import 'package:flip_book/src/widget/page_delegate/page_builder_delegate.dart';
import 'package:flip_book/src/widget/page_delegate/page_delegate.dart';
import 'package:flip_book/src/widget/page_delegate/page_list_delegate.dart';
import 'package:flip_book/src/widgets_ext/multi_animation_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FlipBook extends StatefulWidget {
  static const _defaultAspectRatio = 3 / 2;
  static const _defaultAxis = Axis.horizontal;
  static const _defaultBufferSize = 2;
  static const _defaultPadding = EdgeInsets.all(10);

  static Locale localeInit(Locale? locale) => locale ?? Locale(intl.Intl.getCurrentLocale());
  static TextDirection directionInit(TextDirection? direction, Locale? locale) =>
      direction ?? (intl.Bidi.isRtlLanguage(localeInit(locale).languageCode) ? TextDirection.rtl : TextDirection.ltr);
  static bool totalPagesValidation(int? totalPages) => totalPages != null && totalPages >= 4 && totalPages % 2 == 0;
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
    this.aspectRatio = _defaultAspectRatio,
    this.axis = _defaultAxis,
    this.bufferSize = _defaultBufferSize,
    TextDirection? direction,
    FlipBookController? controller,
    Locale? locale,
    this.onPageChanged,
    this.padding = _defaultPadding,
    this.pageSemantics,
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
    this.addAutomaticKeepAlives = false,
    this.aspectRatio = _defaultAspectRatio,
    this.axis = _defaultAxis,
    this.bufferSize = _defaultBufferSize,
    TextDirection? direction,
    FlipBookController? controller,
    Locale? locale,
    this.onPageChanged,
    required PageBuilder pageBuilder,
    this.padding = _defaultPadding,
    this.pageSemantics,
    int? totalPages,
  })  : assert(totalPagesValidation(controller?.totalPages) || totalPagesValidation(totalPages)),
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

enum Direction { backward, forward }

class FlipBookState extends State<FlipBook> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<FlipBook> {
  Leaf? currentLeaf;
  Size _bgSize = const Size(0, 0);
  Direction? _direction;
  double _delta = 0;
  Size _leafSize = const Size(0, 0);
  late double _startingPos;
  late FlipBookController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.setVsync(this);
  }

  bool get isLTR => widget.direction == TextDirection.ltr;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = widget.controller;
    return LayoutBuilder(builder: (context, constraints) {
      _bgSize = Size(constraints.maxWidth, constraints.maxHeight);
      _leafSize = Size((_bgSize.width - widget.padding.horizontal) / 2, _bgSize.height - widget.padding.vertical);
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
                MultiAnimatiedBuilder(
                    animations: controller.leaves.map((leaf) => leaf.animation),
                    builder: (_, __) => Stack(
                            children: [
                          ...controller.leaves.reversed.where((leaf) => leaf.animationController.value < 0.5),
                          ...controller.leaves.where((leaf) => leaf.animationController.value >= 0.5)
                        ].map((leaf) => leafBuilder(context, leaf)).toList()))
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget leafBuilder(BuildContext context, Leaf leaf) {
    final animationVal = leaf.animationController.value;
    final pageMaterial = Align(
      alignment: isLTR ? Alignment.centerRight : Alignment.centerLeft,
      child: AspectRatio(
          aspectRatio: 2 / 3,
          child: SizedBox(
              height: _leafSize.height,
              width: _leafSize.width,
              child: animationVal < 0.5
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: widget.pageDelegate.build(context, _leafSize, leaf.pages.first))
                  : widget.pageDelegate.build(context, _leafSize, leaf.pages.last))),
    );
    return Positioned.fill(
      top: widget.padding.top,
      bottom: widget.padding.bottom,
      left: (isLTR ? _leafSize.width : 0) + widget.padding.left,
      right: (isLTR ? 0 : _leafSize.width) + widget.padding.right,
      child: Transform.translate(
        offset: Offset(_leafSize.width, 0),
        child: Transform(
          transform: Matrix4.identity()..rotateY(pi),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((isLTR ? -pi : pi) * animationVal),
            alignment: isLTR ? Alignment.centerRight : Alignment.centerLeft,
            child: pageMaterial,
          ),
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    if (currentLeaf != null || controller.animating) {
      _direction = null;
      _startingPos = 0;
      return;
    }
    _startingPos = details.globalPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (controller.animating) {
      return;
    }
    _delta = isLTR ? _startingPos - details.globalPosition.dx : details.globalPosition.dx - _startingPos;
    if (_delta.abs() > _bgSize.width) return;
    if (_delta == 0) return;
    _direction = _direction ?? ((_delta > 0) ? Direction.forward : Direction.backward);
    switch (_direction!) {
      case Direction.forward:
        final pos = _delta / _bgSize.width;
        print(pos);
        // drag overflow
        if (pos > 1) {
          return;
        }
        if (currentLeaf == null) {
          if (controller.isClosedInverted) {
            return;
          } else {
            currentLeaf = controller.currentOrTurningLeaves.item2!;
          }
        }
        controller.currentLeaf.animationController.value = pos;
        break;
      case Direction.backward:
        // reverse
        final pos = 1 - (_delta.abs() / _bgSize.width);
        print(pos);
        // drag overflow
        if (pos < 0) {
          return;
        }
        if (currentLeaf == null) {
          if (controller.isClosed) {
            return;
          } else {
            currentLeaf = controller.currentOrTurningLeaves.item1!;
          }
        }
        controller.currentOrTurningLeaves.item1!.animationController.value = pos;
    }
  }

  void _onDragEnd(DragEndDetails details) async {
    if (currentLeaf == null) {
      _direction = null;
      _startingPos = 0;
      return;
    }
    TickerFuture Function({double? from}) animate;
    final pps = details.velocity.pixelsPerSecond;
    final turningLeafAnimCtrl = currentLeaf!.animationController;
    if (pps.dx.abs() > 500 && (isLTR ? pps.dx <= 0 : pps.dx > 0)) {
      animate = turningLeafAnimCtrl.forward;
    } else if (pps.dx.abs() > 500 && (isLTR ? pps.dx > 0 : pps.dx <= 0)) {
      animate = turningLeafAnimCtrl.reverse;
    } else if (turningLeafAnimCtrl.value > 0.5) {
      animate = turningLeafAnimCtrl.forward;
    } else {
      animate = turningLeafAnimCtrl.reverse;
    }
    controller.animating = true;
    _direction = null;
    _startingPos = 0;
    await animate(from: turningLeafAnimCtrl.value);
    controller.animating = false;
    currentLeaf = null;
  }

  @override
  bool get wantKeepAlive => true;
}
