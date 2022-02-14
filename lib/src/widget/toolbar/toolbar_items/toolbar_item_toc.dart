import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/intl/texts.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items/toolbar_item_jump_to_page.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemTOC extends FlipBookToolbarItemJumpToPage {
  FlipBookToolbarItemTOC(FlipBookController controller,
      FlipBookToolbarItemsConfig itemsConfig, int page)
      : super(
            controller,
            itemsConfig,
            Icon(itemsConfig.direction == TextDirection.ltr
                ? Icons.format_list_numbered
                : Icons.format_list_numbered_rtl),
            page,
            FlipBookTexts.tableOfContents(itemsConfig.locale));
}
