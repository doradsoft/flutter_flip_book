import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/widget/book.dart';
import 'package:flutter/material.dart';
import 'package:flip_book/src/controller/leaf.dart';
import 'package:flip_book/src/widgets_ext/multi_animation_builder.dart';
import 'dart:math';

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
                    animations: controller.leaves.map((leaf) => leaf.animationController),
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
    if (currentLeaf == null || controller.animating) {
      _direction = null;
      _startingPos = 0;
      return;
    }
    TickerFuture Function({double? from}) animate;
    final pps = details.velocity.pixelsPerSecond;
    final turningLeafAnimCtrl = currentLeaf!.animationController;
    switch (_direction!) {
      case Direction.forward:
        if ((pps.dx.abs() > 500 || turningLeafAnimCtrl.value >= 0.5)) {
          animate = turningLeafAnimCtrl.forward;
        } else {
          animate = turningLeafAnimCtrl.reverse;
        }
        break;
      case Direction.backward:
        if ((pps.dx.abs() > 500 || turningLeafAnimCtrl.value <= 0.5)) {
          animate = turningLeafAnimCtrl.reverse;
        } else {
          animate = turningLeafAnimCtrl.forward;
        }
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
