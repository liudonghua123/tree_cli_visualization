import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tree_view/tree_view.dart';

import 'models/document.dart';
import 'widgets/directory_widget.dart';
import 'widgets/file_widget.dart';

void main() => runApp(const MainApplication());

class MainApplication extends StatelessWidget {
  const MainApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OverlaySupport.global(
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  List<Document> _documents = [];
  var logger = Logger();
  late DropzoneViewController dropzoneViewController;

  void _initJsonData(String fileData) async {
    setState(() {
      _isLoading = true;
    });
    logger.d('parse json file');
    final jsonDecoded = jsonDecode(fileData);
    logger.d('parse json file finished');
    toast('parse json file successed!');
    setState(() {
      logger.d("start to execute Document.fromJson(jsonDecoded)");
      _documents = Document.fromJson(jsonDecoded);
      logger.d("finish to execute Document.fromJson(jsonDecoded)");
      _isLoading = false;
    });
  }

  void _handlePickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      var fileBytes = result.files.first.bytes!;
      toast("loading data from file: ${result.files.first.name}");
      _initJsonData(const Utf8Decoder().convert(fileBytes));
      // User canceled the picker
      showSimpleNotification(
        const Text("Parse tree cli json file successfully!"),
        background: Colors.green,
        position: NotificationPosition.bottom,
      );
    } else {
      // User canceled the picker
      showSimpleNotification(
        const Text("You do not select any file!"),
        background: Colors.red,
        position: NotificationPosition.bottom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : TreeView(
            startExpanded: false,
            children: _getChildList(_documents),
          );
    var header = DottedBorder(
      color: Colors.blue,
      strokeWidth: 1,
      child: InkWell(
        onTap: _handlePickFile,
        child: SizedBox(
          height: 200,
          child: Stack(
            children: [
              DropTarget(
                onDragDone: (details) async {
                  var file = details.files.first;
                  showSimpleNotification(
                    Text("loading data from drag and drop file: ${file.name}"),
                    background: Colors.red,
                    position: NotificationPosition.bottom,
                  );
                  setState(() {
                    _isLoading = true;
                  });
                  if (!file.name.endsWith(".json")) {
                    showSimpleNotification(
                      const Text("only support json file"),
                      background: Colors.red,
                      position: NotificationPosition.bottom,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    return;
                  }
                  _initJsonData(await file.readAsString());
                },
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Drag and Drop any tree cli json file here.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Or click to select this type of file.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _documents = [];
                              _isLoading = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Tree cli visualization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            header,
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getChildList(List<Document> childDocuments) {
    return childDocuments.map((document) {
      if (!document.isFile) {
        return Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: TreeViewChild(
            parent: _getDocumentWidget(document: document),
            children: _getChildList(document.childData),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.only(left: 4.0),
        child: _getDocumentWidget(document: document),
      );
    }).toList();
  }

  Widget _getDocumentWidget({required Document document}) => document.isFile
      ? _getFileWidget(document: document)
      : _getDirectoryWidget(document: document);

  DirectoryWidget _getDirectoryWidget({required Document document}) =>
      DirectoryWidget(
        directoryName: document.name,
        lastModified: document.dateModified,
        size: document.size,
      );

  FileWidget _getFileWidget({required Document document}) => FileWidget(
        fileName: document.name,
        lastModified: document.dateModified,
        size: document.size,
      );
}
