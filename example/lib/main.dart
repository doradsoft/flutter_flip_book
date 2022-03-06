// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flip_book/flip_book.dart';
import 'package:flip_book_example/en_page_builder.dart';
import 'package:flip_book_example/he_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlipBookControllers extends ChangeNotifier {
  final flipBookControllerEN = FlipBookController(totalPages: 32);
  final flipBookControllerHE = FlipBookController(totalPages: 10);
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  FlipBookControllers() {
    Set.from({flipBookControllerEN, flipBookControllerHE}).forEach((changeNotifier) => changeNotifier.addListener(() {
          if (!_disposed) notifyListeners();
        }));
  }
}

void main() async {
  ensureInitialized([FlipBookLocales.he]);
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FlipBookControllers()),
        ],
        builder: (context, _) {
          final app = MyApp();
          app.build(context);
          return app;
        }),
  );
}

class MyApp extends StatelessWidget {
  final flipBookToolbarItemsConfigEN = FlipBookToolbarItemsConfig(locale: FlipBookLocales.en);
  final flipBookToolbarItemsConfigHE =
      FlipBookToolbarItemsConfig(locale: FlipBookLocales.he, direction: TextDirection.rtl);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlipBookControllers buildFlipBookControllers = Provider.of<FlipBookControllers>(context);
    return MaterialApp(
      title: 'Flip book example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Row(
        children: [
          Visibility(
            visible: !buildFlipBookControllers.flipBookControllerHE.isFullScreen,
            child: Expanded(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Row(mainAxisSize: MainAxisSize.min, children: [
                    FlipBookToolbarItemFullscreen(
                            buildFlipBookControllers.flipBookControllerEN, flipBookToolbarItemsConfigEN)
                        .child,
                    FlipBookToolbarItemCover(
                            buildFlipBookControllers.flipBookControllerEN, flipBookToolbarItemsConfigEN)
                        .child,
                    FlipBookToolbarItemPrev(buildFlipBookControllers.flipBookControllerEN, flipBookToolbarItemsConfigEN)
                        .child,
                    FlipBookToolbarItemNext(buildFlipBookControllers.flipBookControllerEN, flipBookToolbarItemsConfigEN)
                        .child,
                    FlipBookToolbarItemTOC(
                            buildFlipBookControllers.flipBookControllerEN, flipBookToolbarItemsConfigEN, 5)
                        .child,
                  ]),
                ),
                Expanded(
                  child: FlipBook.builder(
                    controller: buildFlipBookControllers.flipBookControllerEN,
                    pageBuilder: enPageBuilder,
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                )
              ]),
            ),
          ),
          Visibility(
            visible: !buildFlipBookControllers.flipBookControllerEN.isFullScreen ||
                (buildFlipBookControllers.flipBookControllerHE.isFullScreen &&
                    buildFlipBookControllers.flipBookControllerEN.isFullScreen),
            // visible: true,
            child: Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: Row(mainAxisSize: MainAxisSize.min, children: [
                      FlipBookToolbarItemFullscreen(
                              buildFlipBookControllers.flipBookControllerHE, flipBookToolbarItemsConfigHE)
                          .child,
                      FlipBookToolbarItemCover(
                              buildFlipBookControllers.flipBookControllerHE, flipBookToolbarItemsConfigHE)
                          .child,
                      FlipBookToolbarItemPrev(
                              buildFlipBookControllers.flipBookControllerHE, flipBookToolbarItemsConfigHE)
                          .child,
                      FlipBookToolbarItemNext(
                              buildFlipBookControllers.flipBookControllerHE, flipBookToolbarItemsConfigHE)
                          .child,
                      FlipBookToolbarItemTOC(
                              buildFlipBookControllers.flipBookControllerHE, flipBookToolbarItemsConfigHE, 5)
                          .child,
                    ]),
                  ),
                  Expanded(
                    child: FlipBook.builder(
                      controller: buildFlipBookControllers.flipBookControllerHE,
                      direction: TextDirection.rtl,
                      pageSemantics: hePageSemantics,
                      pageBuilder: hePageBuilder,
                    ),
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
