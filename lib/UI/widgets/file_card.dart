import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:syncit/share.dart';

class FileCard extends StatefulWidget {
  final int index;
  final String fileName;
  final void Function(String, BuildContext) deleteFile;
  FileCard(
      {Key? key,
      required this.fileName,
      required this.deleteFile,
      required this.index})
      : super(key: key);

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.fileName,
      triggerMode: TooltipTriggerMode.tap,
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
          // height: 150,
          // width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                getIcon(widget.fileName),
                // size: 60,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  widget.fileName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              if (context.watch<Share>().sendingFileIndex < widget.index)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => widget.deleteFile(widget.fileName, context),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              if (context.watch<Share>().sendingFileIndex > widget.index)
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ThemeColor.green),
                  child: Icon(
                    Icons.done,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              if (context.watch<Share>().sendingFileIndex == widget.index)
                Container(
                  // padding: EdgeInsets.all(5),
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    value: context.watch<Share>().percentSent,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: Colors.grey,
                    strokeWidth: 5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData getIcon(String fileName) {
  final type = lookupMimeType(fileName)?.split('/')[0];
  if (type == 'audio')
    return Icons.music_note;
  else if (type == 'video')
    return Icons.video_file;
  else if (type == 'image')
    return Icons.image;
  else
    return Icons.feed_outlined;
}
