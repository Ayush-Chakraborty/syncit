// ignore_for_file: constant_identifier_names
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import './receiver.dart';
import './sender.dart';

class CommunicationChannel {
  static const START_SEND = "START_SEND";
  static const FINISH_SEND = "FINISH_SEND";
  static const OK_SEND = "OK_SEND";
  static const OK_RECEIVED = "OK_RECEIVED";
  static const OK_SEND_CHUNK = "OK_SEND_CHUNK";
  static const OK = "OK";

  final WebSocket socket;
  String? destinationPath;
  Receiver? receiver;
  Sender? sender;
  final void Function(double percentage, int index) onSharing;

  CommunicationChannel(
      {required this.socket, this.destinationPath, required this.onSharing}) {
    receiver = Receiver(
        socket: socket, destinationPath: destinationPath, onSharing: onSharing);
  }

  void changeDestinationPath(String path) {
    receiver?.destinationPath = path;
  }

  void sendFiles(List<PlatformFile> files) {
    if (files.isEmpty) return;
    sender = Sender(files: files, socket: socket, onSharing: onSharing);
    receiver?.setSender(sender!);
    final fileDesc = sender?.sendFile();
    if (fileDesc != null) {
      receiver?.setFileName(fileDesc);
    }
    socket.add(START_SEND);
  }
}
