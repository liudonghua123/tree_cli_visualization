import 'package:flutter/material.dart';

import '../utils/utils.dart';

class DirectoryWidget extends StatelessWidget {
  final String directoryName;
  final DateTime lastModified;
  final int size;
  final int level;
  final VoidCallback? onPressedNext;

  const DirectoryWidget({
    Key? key,
    required this.directoryName,
    required this.lastModified,
    this.size = 0,
    this.level = 1,
    this.onPressedNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(directoryName);
    Icon folderIcon = const Icon(Icons.folder);

    IconButton expandButton = IconButton(
      icon: const Icon(Icons.navigate_next),
      onPressed: onPressedNext,
    );

    Widget lastModifiedWidget = Text(
      Utils.getFormattedDateTime(dateTime: lastModified),
    );

    Widget fileSizeWidget = Text(
      Utils.getFormattedFileSize(size: size),
    );

    return Card(
      color: Colors.lightBlueAccent,
      margin: EdgeInsets.only(left: level * 4.0, top: 4.0, bottom: 4.0),
      child: ListTile(
        leading: folderIcon,
        title: titleWidget,
        subtitle: fileSizeWidget,
        trailing: expandButton,
        onTap: () => {},
      ),
    );
  }
}
