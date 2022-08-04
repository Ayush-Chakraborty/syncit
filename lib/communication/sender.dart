// ignore_for_file: constant_identifier_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncit/share.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';

import './communication_channel.dart';
import 'package:provider/provider.dart';

class Sender {
  static const MAX_CHUNK = 100 * 65500;

  final List<PlatformFile> files;
  final WebSocket socket;
  File? _selectedFile;
  var _inputStream = StreamController<List<int>>().stream;

  var _sendingFileIndex = -1;
  var _percentageSent = 0.0;
  var _totalSize = 0;
  var _sizeSent = 0;
  var _lastSizeSent = 0;
  final void Function(double percentage, int index) onSharing;

  Sender({required this.files, required this.socket, required this.onSharing});

  String? sendFile() {
    // _isFileSharing = true;

    _sendingFileIndex++;
    if (_sendingFileIndex >= files.length) {
      onSharing(0, -1);
      return null;
    }
    final file = files[_sendingFileIndex];
    onSharing(0, _sendingFileIndex);
    final fileName = file.name;
    _selectedFile = File(file.path ?? '');
    _totalSize = file.size;
    _sizeSent = 0;
    return '$fileName ${file.size}';
  }

  void sendChunkSize() {
    if (_sizeSent >= _totalSize) {
      socket.add(CommunicationChannel.FINISH_SEND);
      return;
    }
    _lastSizeSent = _sizeSent;
    if (_sizeSent + MAX_CHUNK >= _totalSize) {
      _inputStream = _selectedFile?.openRead(_sizeSent) as Stream<List<int>>;
      _sizeSent = _totalSize;
    } else {
      _inputStream = _selectedFile?.openRead(_sizeSent, _sizeSent + MAX_CHUNK)
          as Stream<List<int>>;
      _sizeSent += MAX_CHUNK;
    }
    socket.add((_sizeSent - _lastSizeSent).toString());
  }

  void sendChunk() {
    var temp = _lastSizeSent;
    _inputStream.listen((data) {
      socket.add(data);
      temp = min(_sizeSent, temp + data.length);
      onSharing((temp / _totalSize), _sendingFileIndex);
    });
  }
}
