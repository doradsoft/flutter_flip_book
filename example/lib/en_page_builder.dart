// import 'package:flip_book/flip_book.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const enPages = [
  "000-introduction.md",
  "001-databases.md",
  "002-install-mysql.md",
  "003-creating-tables.md",
  "004-basic-syntax.md",
  "005-select.md",
  "006-where.md",
  "007-order-and-group-by.md",
  "008-insert.md",
  "009-update.md",
  "010-delete.md",
  "011-join.md",
  "012-sql-commnad-categories.md",
  "013-sub-queries.md",
  "014-unions.md",
  "015-Keys-in-a-Relational Database.md",
  "016-Logical-operator-keywords.md",
  "017-having-clause_aggregate-functions.md",
  "018-essential-mysql-functions.md",
  "019-triggers-in-sql.md",
  "020-TCL-commands.md",
  "021-DCL-commands.md",
  "100-mysqldump.md",
  "101-learn-materialize.md",
  "999-conclusion.md"
];
Widget enPageBuilder(context, pageSize, pageIndex, semanticPageName) {
  Widget pageBody = const SizedBox.shrink();
  switch (pageIndex) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
    default:
      final mdFilePath = path.join(kIsWeb ? "" : "assets", "pages_data", "en", "content", enPages[pageIndex - 3]);
      pageBody = FutureBuilder<String>(
          future: rootBundle.loadString(mdFilePath),
          builder: (_, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Markdown(
                data: snapshot.data ?? "",
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
      SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(child: pageBody)]),
        ),
      )
    ],
  );
}
