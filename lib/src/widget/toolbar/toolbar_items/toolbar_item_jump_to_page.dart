import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_item.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemJumpToPage extends ToolbarItem {
  FlipBookToolbarItemJumpToPage(
      FlipBookController controller,
      FlipBookToolbarItemsConfig itemsConfig,
      Widget icon,
      int page,
      String tooltip,
      {duration = const Duration(milliseconds: 800),
      curve = Curves.easeInOutQuad})
      : super(
            controller,
            itemsConfig,
            (context) => IconButton(
                  icon: icon,
                  onPressed: () {
                    controller.animateTo(page,
                        duration: duration, curve: curve);
                  },
                  tooltip: tooltip,
                ));
}
