import 'package:flip_book/flip_book.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

final hePageSemanticsDict = {4: "א", 5: "ב", 6: "ג"};
Widget hePageBuilder(context, pageSize, pageIndex, semanticPageName) {
  Widget pageBody;

  if (semanticPageName == "") {
    pageBody = const SizedBox.shrink();
  } else {
    final textFilePath = path.join(kIsWeb ? "" : "assets", "pages_data", "he",
        "${hePageSemanticsDict.entries.firstWhere((entry) => entry.value == semanticPageName).key}.txt");
    pageBody = FutureBuilder<String>(
        future: rootBundle.loadString(textFilePath),
        builder: (_, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              snapshot.data ?? "",
              textAlign: TextAlign.justify,
            ),
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
}

final PageSemantics hePageSemantics = PageSemantics(indexToSemanticName: (pageIndex) {
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
});
