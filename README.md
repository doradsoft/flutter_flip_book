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



https://user-images.githubusercontent.com/5598420/156990150-a7dcc561-1708-4db0-83b4-eac81736f4ad.mp4



## Features

* RTL
* Aspect Ratio
* Page Builder

## Additional information

The package is in under construction.

## Development


### Internationalization 
Each locale translations are defined in `./lib/l10n/intl_<locale>.arb`

#### Adding a new locale
1. Run: `Flutter Intl: Add locale`
2. Edit `./lib/src/intl/locales.dart`.


#### Adding a new Internationalized text
1. Copy text getter from `./lib/generated/l10n.dart` into `./lib/src/intl/text.dart`
2. Replace getter signature with a `String <getter_name> (Locale locale)` function.
3. Append `locale: locale.toString()` parameter to Intl.message call.
