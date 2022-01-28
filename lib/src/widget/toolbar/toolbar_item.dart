import 'package:flip_book/src/controller/book_controller.dart';
import 'package:flip_book/src/provider_ext/change_notifier_consumer.dart';
import 'package:flip_book/src/widget/toolbar/toolbar_items_config.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class ToolbarItem {
  final Widget Function(BuildContext, FlipBookController, Widget?) builder;
  late Widget child;
  final FlipBookController controller;
  final FlipBookToolbarItemsConfig itemsConfig;
  ToolbarItem(this.controller, this.itemsConfig, this.builder) {
    // child = ChangeNotifierProvider(
    //     create: (_) => controller,
    //     child: Consumer<FlipBookController>(
    //       builder: builder,
    //     ));
    child = ChangeNotifierConsumer<FlipBookController>(
        changeNotifier: controller, builder: builder);
  }
}
