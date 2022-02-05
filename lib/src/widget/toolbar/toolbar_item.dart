import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';

class ToolbarItem {
  final Widget Function(BuildContext) builder;
  late Widget child;
  final FlipBookController controller;
  final FlipBookToolbarItemsConfig itemsConfig;
  ToolbarItem(this.controller, this.itemsConfig, this.builder) {
    child = Builder(builder: builder);
  }
}
