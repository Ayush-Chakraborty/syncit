import 'package:flutter/cupertino.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:syncit/UI/widgets/file_card.dart';
import 'package:syncit/UI/widgets/received_file_card.dart';
import 'package:syncit/services/file_client.dart';

class ReceivedFiles extends StatefulWidget {
  const ReceivedFiles({Key? key}) : super(key: key);

  @override
  State<ReceivedFiles> createState() => _ReceivedFilesState();
}

class _ReceivedFilesState extends State<ReceivedFiles> {
  List<io.FileSystemEntity> file = [];
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    String directory = (await FileClient.getPath());
    setState(() {
      file = io.Directory(directory)
          .listSync(); //use your folder name insted of resume.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children:
                    file.map((e) => ReceivedFileCard(path: e.path)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
