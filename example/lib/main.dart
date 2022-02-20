// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flip_book/flip_book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class FlipBookControllers extends ChangeNotifier {
  final flipBookControllerEN = FlipBookController(totalPages: 10);
  final flipBookControllerHE = FlipBookController(totalPages: 8);
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
  final hePageSemanticsDict = {4: "א", 5: "ב", 6: "ג"};

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
                    pageBuilder: (context, pageSize, pageIndex, semanticPageName) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("page ${pageIndex + 1}")]);
                    },
                    // padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                )
              ]),
            ),
          ),
          Visibility(
            visible: !buildFlipBookControllers.flipBookControllerEN.isFullScreen,
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
                      pageSemantics: PageSemantics(indexToSemanticName: (pageIndex) {
                        return hePageSemanticsDict[pageIndex] ?? "";
                      }, semanticNameToIndex: (String semanticPageName) {
                        return hePageSemanticsDict.containsValue(semanticPageName)
                            ? hePageSemanticsDict.entries.firstWhere((entry) => entry.value == semanticPageName).key
                            : null;
                      }, indexToTitle: (pageIndex) {
                        final chapter = hePageSemanticsDict[pageIndex];
                        if (chapter == null) {
                          return "";
                        } else {
                          return "פרק $chapter";
                        }
                      }),
                      pageBuilder: (context, pageSize, pageIndex, semanticPageName) {
                        Widget pageBody;

                        if (semanticPageName == "") {
                          pageBody = const SizedBox.shrink();
                        } else {
                          final textFilePath = path.join(kIsWeb ? "" : "assets", "pages_data", "he",
                              "${hePageSemanticsDict.entries.firstWhere((entry) => entry.value == semanticPageName).key}.txt");
                          pageBody = FutureBuilder<String>(
                              future: rootBundle.loadString(textFilePath),
                              builder: (_, snapshot) {
                                if (kDebugMode) {
                                  print("buildingPage");
                                }
                                return RichText(
                                  text: TextSpan(text: snapshot.data ?? ""),
                                );
                              });
                        }
                        return Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(child: Container(color: Colors.white)),
                              ],
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Expanded(child: pageBody)])
                          ],
                        );
                      },
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
