import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perceptron/page/simulacion/view_csw.dart';

class CsvWardPage extends StatefulWidget {

  @override
  _CsvWardPageState createState() => _CsvWardPageState();
}

class _CsvWardPageState extends State<CsvWardPage> {
  
  List<List<dynamic>> peso = [] ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PESOS GUARDADOS")),
      body: FutureBuilder(
        future: _getAllCsvFiles(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("empty");
          }
          print('${snapshot.data!.length} ${snapshot.data}');
          if (snapshot.data!.length == 0) {
            return Center(
              child: Text('No Csv File found.'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) => Card(
              child: ListTile(
                  onTap: () {
                    peso = [];
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ViewCsvPage(path: snapshot.data![index].path)
                    ));
                  },
                  title: Text(
                    snapshot.data![index].path.substring(62),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }

}

 Future<List<FileSystemEntity>> _getAllCsvFiles() async {
    final String directory = (await getExternalStorageDirectory())!.path;
    final path = "$directory/";
    final myDir = Directory(path);
    List<FileSystemEntity> _csvFiles;
    _csvFiles = myDir.listSync(recursive: true, followLinks: false);
    _csvFiles.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _csvFiles;
}
