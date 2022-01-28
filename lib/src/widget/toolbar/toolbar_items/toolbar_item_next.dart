import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_item.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemNext extends ToolbarItem {
  FlipBookToolbarItemNext(
      FlipBookController controller, FlipBookToolbarItemsConfig itemsConfig)
      : super(
            controller,
            itemsConfig,
            (context, controller, child) => IconButton(
                onPressed: controller.animateNext,
                icon: Icon(itemsConfig.direction == TextDirection.ltr
                    ? Icons.arrow_forward
                    : Icons.arrow_back)));
}
