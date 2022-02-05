<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Flutter flip book widget

## Features

* RTL
* Aspect Ratio
* Page Builder

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
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
```

## Additional information

The package is still in not usable. After I stabilize it, you can open issues.

## Development


### Internationalization 
Each locale translations are defined in `./lib/l10n/intl_<locale>.arb`

#### Adding a new locale
1. Run: `Flutter Intl: Add locale`
2. Edit `./lib/src/intl/locales.dart`.


### Adding a new Internationalized text
1. Copy text getter from `./lib/generated/l10n.dart` into `./lib/src/intl/text.dart`
2. Replace getter signature with a `String <getter_name> (Locale locale)` function.
3. Append `locale: locale.toString()` parameter to Intl.message call.