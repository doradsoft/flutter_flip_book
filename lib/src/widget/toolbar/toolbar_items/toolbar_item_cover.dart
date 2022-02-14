import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/intl/texts.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items/toolbar_item_jump_to_page.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemCover extends FlipBookToolbarItemJumpToPage {
  FlipBookToolbarItemCover(
      FlipBookController controller, FlipBookToolbarItemsConfig itemsConfig)
      : super(controller, itemsConfig, const Icon(Icons.first_page_sharp), 0,
            FlipBookTexts.cover(itemsConfig.locale));
}
