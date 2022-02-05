import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/intl/texts.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_item.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class FlipBookToolbarItemFullscreen extends ToolbarItem {
  FlipBookToolbarItemFullscreen(
      FlipBookController controller, FlipBookToolbarItemsConfig itemsConfig)
      : super(
            controller,
            itemsConfig,
            (context) => IconButton(
                  icon: Icon(controller.isFullScreen
                      ? Icons.fullscreen_exit_sharp
                      : Icons.fullscreen_sharp),
                  onPressed: controller.toggleFullScreen,
                  tooltip: FlipBookTexts.fullScreen(itemsConfig.locale),
                ));
}
