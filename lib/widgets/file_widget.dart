import 'package:flutter/material.dart';

import '../utils/utils.dart';

class FileWidget extends StatelessWidget {
  final String fileName;
  final DateTime lastModified;
  final int size;
  final int level;

  const FileWidget({
    Key? key,
    required this.fileName,
    required this.lastModified,
    this.size = 0,
    this.level = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget fileNameWidget = Text(fileName);
    Widget lastModifiedWidget = Text(
      Utils.getFormattedDateTime(dateTime: lastModified),
    );

    Widget fileSizeWidget = Text(
      Utils.getFormattedFileSize(size: size),
    );
    Icon fileIcon = const Icon(Icons.insert_drive_file);

    return Card(
      margin: EdgeInsets.only(left: level * 4.0, top: 4.0, bottom: 4.0),
      elevation: 0.0,
      child: ListTile(
        leading: fileIcon,
        title: fileNameWidget,
        subtitle: fileSizeWidget,
        onTap: () => {},
      ),
    );
  }
}
