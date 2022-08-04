import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

class LastCopied {
  static String str = '';
}

Stream<String> clipboardSync() {
  // String prev = '';
  final streamController = StreamController<String>();
  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if ((Platform.isWindows && DateTime.now().second % 2 == 0) ||
        (Platform.isAndroid && DateTime.now().second % 2 == 1)) {
      Clipboard.getData('text/plain').then((value) {
        final text = value?.text;
        if (text != LastCopied.str) {
          streamController.sink.add(text!);
          LastCopied.str = text;
        }
      });
    }
  });
  streamController.onCancel = () => timer.cancel();
  return streamController.stream;
}
