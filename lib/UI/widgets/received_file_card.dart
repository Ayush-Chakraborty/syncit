import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncit/services/file_client.dart';
import 'file_card.dart';
import 'package:path/path.dart';

class ReceivedFileCard extends StatelessWidget {
  final String path;
  const ReceivedFileCard({required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Platform.isWindows ? FileClient.openFolder() : OpenFile.open(path),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: basename(path),
          triggerMode: TooltipTriggerMode.longPress,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        color: Colors.black12)
                  ]),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    getIcon(basename(path)),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      basename(path),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
