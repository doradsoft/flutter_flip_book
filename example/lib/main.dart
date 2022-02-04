import 'package:flip_book/flip_book.dart';
import 'package:flutter/material.dart';

void main() async {
  ensureInitialized([FlipBookLocales.he]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flipBookControllerEN = FlipBookController(totalPages: 4);
  final flipBookToolbarItemsConfigEN =
      FlipBookToolbarItemsConfig(locale: FlipBookLocales.en);
  final flipBookControllerHE = FlipBookController(totalPages: 4);
  final flipBookToolbarItemsConfigHE = FlipBookToolbarItemsConfig(
      locale: FlipBookLocales.he, direction: TextDirection.rtl);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip book example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Row(
        children: [
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Row(mainAxisSize: MainAxisSize.min, children: [
                  FlipBookToolbarItemPrev(
                          flipBookControllerEN, flipBookToolbarItemsConfigEN)
                      .child,
                  FlipBookToolbarItemNext(
                          flipBookControllerEN, flipBookToolbarItemsConfigEN)
                      .child,
                  FlipBookToolbarItemFullscreen(
                          flipBookControllerEN, flipBookToolbarItemsConfigEN)
                      .child,
                ]),
              ),
              Expanded(
                child: FlipBook.builder(
                  controller: flipBookControllerEN,
                  itemBuilder: (context, index) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("page ${index + 1}")]);
                  },
                  // padding: const EdgeInsets.symmetric(vertical: 10),
                  totalPages: 4,
                ),
              )
            ]),
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Row(mainAxisSize: MainAxisSize.min, children: [
                    FlipBookToolbarItemNext(
                            flipBookControllerHE, flipBookToolbarItemsConfigHE)
                        .child,
                    FlipBookToolbarItemPrev(
                            flipBookControllerHE, flipBookToolbarItemsConfigHE)
                        .child,
                    FlipBookToolbarItemFullscreen(
                            flipBookControllerHE, flipBookToolbarItemsConfigHE)
                        .child,
                  ]),
                ),
                Expanded(
                  child: FlipBook.builder(
                    controller: flipBookControllerHE,
                    direction: TextDirection.rtl,
                    itemBuilder: (context, index) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("page ${index + 1}")]);
                    },
                    totalPages: 4,
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
