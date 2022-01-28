import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_item.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemPrev extends ToolbarItem {
  FlipBookToolbarItemPrev(
      FlipBookController controller, FlipBookToolbarItemsConfig itemsConfig)
      : super(
            controller,
            itemsConfig,
            (context, controller, child) => IconButton(
                onPressed: controller.animatePrev,
                tooltip: "l10",
                icon: Icon(itemsConfig.direction == TextDirection.ltr
                    ? Icons.arrow_back
                    : Icons.arrow_forward)));
}
