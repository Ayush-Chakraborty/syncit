import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:syncit/UI/widgets/file_card.dart';
import 'package:syncit/services/file_client.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:syncit/share.dart';

class DragDrop extends StatefulWidget {
  const DragDrop({Key? key}) : super(key: key);

  @override
  State<DragDrop> createState() => _DragDropState();
}

class _DragDropState extends State<DragDrop> {
  // List<PlatformFile> _list = [];
  bool _dragging = false;
  void deleteFile(String fileName, BuildContext context) {
    List<PlatformFile> newList = [];
    for (var item in context.read<Share>().files) {
      if (item.name != fileName) newList.add(item);
    }
    context.read<Share>().setFiles(newList);
  }

  void selectFiles(BuildContext context) async {
    final list = context.read<Share>().files;
    List<PlatformFile> files = await FileClient.pickfiles();
    list.addAll(files);
    context.read<Share>().setFiles(list);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => DropTarget(
        onDragDone: (detail) {
          for (var xfile in detail.files) {
            final file = File(xfile.path);
            final list = context.read<Share>().files;
            list.add(PlatformFile(
                path: file.path,
                name: basename(xfile.name),
                size: file.lengthSync()));
            context.read<Share>().setFiles(list);
          }
        },
        onDragEntered: (detail) {
          setState(() {
            _dragging = true;
          });
        },
        onDragExited: (detail) {
          setState(() {
            _dragging = false;
          });
        },
        child: DottedBorder(
          color: context.watch<Share>().files.isEmpty
              ? Colors.black
              : Colors.transparent,
          strokeWidth: 1,
          radius: const Radius.circular(15),
          borderType: BorderType.RRect,
          dashPattern: [10],
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: _dragging
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent,
                border: context.watch<Share>().files.isEmpty
                    ? null
                    : Border.all(
                        color: Colors.black38,
                        width: 1,
                        style: BorderStyle.solid)),
            child: context.watch<Share>().files.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Drop your files here",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54)),
                      const SizedBox(
                        height: 30,
                        width: double.infinity,
                      ),
                      ElevatedButton(
                          onPressed: () => selectFiles(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.file_present),
                                SizedBox(width: 10),
                                Text(
                                  "Select Files",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ))
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              children: context
                                  .watch<Share>()
                                  .files
                                  .indexedMap((value, index) => FileCard(
                                        index: index,
                                        fileName: value.name,
                                        deleteFile: deleteFile,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid))),
                        // ),,

                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Container()),
                            OutlinedButton(
                              onPressed: () {
                                context.read<Share>().setFiles([]);
                              },
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      const BorderSide(
                                          color: ThemeColor.red,
                                          style: BorderStyle.solid,
                                          width: 2)),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15))),
                              child: const Text("Cancel",
                                  style: TextStyle(
                                      color: ThemeColor.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 25),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<Share>().sendFiles(),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15))),
                              child: const Text("Send",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Expanded(child: Container()),
                            Tooltip(
                              message: "add more items",
                              child: ElevatedButton(
                                onPressed: () => selectFiles(context),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(18)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> indexedMap<T>(T Function(E element, int index) f) {
    var index = 0;
    return map((e) => f(e, index++));
  }
}
