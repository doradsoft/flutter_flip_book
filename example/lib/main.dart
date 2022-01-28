import 'package:flip_book/flip_book.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final flipBookController = FlipBookController(totalPages: 4);
  final FlipBookToolbarItemsConfig flipBookToolbarItemsConfig =
      FlipBookToolbarItemsConfig();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            FlipBookToolbarItemPrev(
                    flipBookController, flipBookToolbarItemsConfig)
                .child,
            FlipBookToolbarItemNext(
                    flipBookController, flipBookToolbarItemsConfig)
                .child,
            FlipBookToolbarItemFullscreen(
                    flipBookController, flipBookToolbarItemsConfig)
                .child,
          ]),
        ),
        body: FlipBook.builder(
          controller: flipBookController,
          itemBuilder: (context, index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("page ${index + 1}")]);
          },
          // padding: const EdgeInsets.symmetric(vertical: 10),
          totalPages: 4,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
