import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/document.dart';
import 'widgets/directory_widget.dart';
import 'widgets/file_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:tree_view/tree_view.dart';

void main() => runApp(const MainApplication());

class MainApplication extends StatelessWidget {
  const MainApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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
  bool _isLoading = true;
  List<Document> _documents = [];
  var logger = Logger();

  _HomePageState() {
    initJsonData();
  }

  void initJsonData() async {
    // parse json file from assets/sdk-tree.json
    logger.d('parse json file');
    final json = await rootBundle.loadString('assets/sdk-tree.json');
    final jsonDecoded = jsonDecode(json);
    logger.d('parse json file finished');
    setState(() {
      logger.d("start to execute Document.fromJson(jsonDecoded)");
      _documents = Document.fromJson(jsonDecoded);
      logger.d("finish to execute Document.fromJson(jsonDecoded)");
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Tree View demo'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TreeView(
              startExpanded: false,
              children: _getChildList(_documents),
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
      );

  FileWidget _getFileWidget({required Document document}) => FileWidget(
        fileName: document.name,
        lastModified: document.dateModified,
      );
}
