import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
ChangeNotifierProvider<T> ChangeNotifierConsumer<T extends ChangeNotifier>(
        {required T changeNotifier,
        required Widget Function(BuildContext, T, Widget?) builder}) =>
    ChangeNotifierProvider(
        create: (_) => changeNotifier,
        child: Consumer<T>(
          builder: builder,
        ));

// class ChangeNotifierConsumer<T extends ChangeNotifier>
//     extends ChangeNotifierProvider {
//   ChangeNotifierConsumer(
//       {required T changeNotifier,
//       required Widget Function(BuildContext, T, Widget?) builder})
//       : super(
//             create: (_) => changeNotifier,
//             child: Consumer<T>(
//               builder: builder,
//             ));
// }
