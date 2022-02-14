import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/intl/texts.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_item.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemNext extends ToolbarItem {
  FlipBookToolbarItemNext(
      FlipBookController controller, FlipBookToolbarItemsConfig itemsConfig)
      : super(
          controller,
          itemsConfig,
          (context) => Directionality(
            textDirection: itemsConfig.direction,
            child: IconButton(
              icon: const Icon(Icons.navigate_next_sharp),
              onPressed: controller.animateNext,
              tooltip: FlipBookTexts.next(itemsConfig.locale),
            ),
          ),
        );
}
