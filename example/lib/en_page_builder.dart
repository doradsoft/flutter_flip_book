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
  "012-sql-command-categories.md",
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
Widget enPageBuilder(context, pageSize, pageIndex, semanticPageName) =>
    LayoutBuilder(builder: (context, constraints) {
      Widget pageBody = const SizedBox.shrink();
      final pageBG = Column(
        children: [
          Expanded(child: Container(color: Colors.white)),
        ],
      );
      const borderFactor = 0.006;
      const frameFactorH = 0.0131;
      const frameFactorW = 0.017;
      const coverColor = Color.fromARGB(255, 1, 22, 39);
      Widget bg = const SizedBox.shrink();
      switch (pageIndex) {
        case 0:
          bg = Column(
            children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width * borderFactor),
                          bottomRight: Radius.circular(
                              MediaQuery.of(context).size.width *
                                  borderFactor)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: coverColor,
                            image: DecorationImage(
                                image: AssetImage(
                                  path.join(
                                      kIsWeb ? "" : "assets",
                                      "pages_data",
                                      "en",
                                      "assets",
                                      "cover.jpg"),
                                ),
                                fit: BoxFit.cover)),
                      ))),
            ],
          );
          break;
        case 1:
          bg = Column(
            children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width * borderFactor),
                          bottomLeft: Radius.circular(
                              MediaQuery.of(context).size.width *
                                  borderFactor)),
                      child: Container(
                        color: coverColor,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width *
                                    frameFactorW,
                                MediaQuery.of(context).size.height *
                                    frameFactorH,
                                0,
                                MediaQuery.of(context).size.height *
                                    frameFactorH),
                            child: Container(color: Colors.white)),
                      ))),
            ],
          );
          break;
        case 2:
          bg = pageBG;
          break;
        case 3:
          bg = pageBG;
          break;
        case 4:
          bg = pageBG;
          break;
        case 30:
          bg = Column(
            children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width * borderFactor),
                          bottomRight: Radius.circular(
                              MediaQuery.of(context).size.width *
                                  borderFactor)),
                      child: Container(
                        color: coverColor,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                MediaQuery.of(context).size.height *
                                    frameFactorH,
                                MediaQuery.of(context).size.width *
                                    frameFactorW,
                                MediaQuery.of(context).size.height *
                                    frameFactorH),
                            child: Container(color: Colors.white)),
                      ))),
            ],
          );
          break;
        case 31:
          bg = Column(
            children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width * borderFactor),
                          bottomLeft: Radius.circular(
                              MediaQuery.of(context).size.width *
                                  borderFactor)),
                      child: Container(color: coverColor))),
            ],
          );
          break;
        default:
          bg = pageBG;
          final mdFilePath = path.join(kIsWeb ? "" : "assets", "pages_data",
              "en", "content", enPages[pageIndex - 5]);
          pageBody = SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: FutureBuilder<String>(
                            future: rootBundle.loadString(mdFilePath),
                            builder: (_, snapshot) {
                              String data = snapshot.data ?? "";
                              if (data.isNotEmpty) {
                                data = data.replaceAll(
                                    "../assets",
                                    path.join(kIsWeb ? "" : "assets",
                                        "pages_data", "en", "assets"));
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Markdown(
                                  data: data,
                                ),
                              );
                            }))
                  ]),
            ),
          );
      }
      return Stack(
        children: [bg, pageBody],
      );
    });
