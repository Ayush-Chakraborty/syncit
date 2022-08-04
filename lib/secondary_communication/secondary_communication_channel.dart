// ignore_for_file: constant_identifier_names
import 'package:flutter/services.dart';
import 'dart:io';

class SecondaryCommunicationChannel {
  static const CLIPBOARD = "__CLIPBOARD__";
  static const SEND_CLIPBOARD = "__SEND_CLIPBOARD__";

  final WebSocket socket;
  var _clipboard = false;
  SecondaryCommunicationChannel({required this.socket});
  void clipBoardHandler() {
    socket.add(CLIPBOARD);
    print("HELLO");
  }

  void receiveHandler(dynamic event) async {
    print(event);
    if (_clipboard) {
      _clipboard = false;
      await Clipboard.setData(event);
    } else if (event == CLIPBOARD) {
      _clipboard = true;
      socket.add(SEND_CLIPBOARD);
    } else if (event == SEND_CLIPBOARD) {
      var text = '';
      Clipboard.getData('text/plain').then((value) {
        text = value?.text ?? '';
      });
      socket.add(text);
    }
  }
}
