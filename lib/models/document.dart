// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:logger/logger.dart';

class Document {
  final String name;
  final bool isFile;
  final DateTime dateModified;
  final int size;
  final List<Document> childData;
  final int level;
  static var logger = Logger();

  Document({
    required this.name,
    DateTime? dateModified,
    this.isFile = false,
    this.size = 0,
    this.childData = const <Document>[],
    this.level = 1,
  }) : dateModified = DateTime.now();

  static List<Document> fromJson(List<dynamic> jsonDecoded, [int level = 0]) {
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
      if (json['size'] == null) {
        json['size'] = 0;
      }
      return Document(
        name: json['name'] as String,
        isFile: json['type'] == 'file',
        size: json['size'] as int,
        childData: childData,
      );
    }).toList();
  }
}
