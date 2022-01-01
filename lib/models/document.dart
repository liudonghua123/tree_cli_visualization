import 'package:logger/logger.dart';

class Document {
  final String name;
  final bool isFile;
  final DateTime dateModified;
  final List<Document> childData;
  final int level;
  static var logger = Logger();

  Document({
    required this.name,
    DateTime? dateModified,
    this.isFile = false,
    this.childData = const <Document>[],
    this.level = 1,
  }) : dateModified = DateTime.now();

  static List<Document> fromJson(List<dynamic> jsonDecoded, [int level = 0]) {
    // var list = <Document>[];
    // jsonDecoded.forEach((json) {
    //   var childData = const <Document>[];
    //   if (json['type'] == 'directory' || json['type'] == 'link') {
    //     childData =
    //         Document.fromJson(json['contents'] as List<dynamic>, level + 1);
    //   }
    //   if (json['error'] != null) {
    //     logger.e('when process json: ${json}, error: ${json['error']}');
    //     return;
    //   }
    //   list.add(Document(
    //     name: json['name'] as String,
    //     isFile: json['type'] == 'file',
    //     childData: childData,
    //     level: level,
    //   ));
    // });
    // return list;
    return jsonDecoded.map((dynamic json) {
      var childData = const <Document>[];
      if (json['error'] != null) {
        logger.e('when process json: ${json}, error: ${json['error']}');
        json['name'] = json['error'];
      }
      if ((json['type'] == 'directory' || json['type'] == 'link') &&
          json['contents'] != null) {
        childData =
            Document.fromJson(json['contents'] as List<dynamic>, level + 1);
      } else {
        // overwrite type if it's a file link
        json['type'] = 'file';
      }
      return Document(
        name: json['name'] as String,
        isFile: json['type'] == 'file',
        childData: childData,
      );
    }).toList();
  }
}
