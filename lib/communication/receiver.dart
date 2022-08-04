// ignore_for_file: constant_identifier_names

import 'dart:io';

import '../services/file_client.dart';
import './communication_channel.dart';
import './sender.dart';

class Receiver {
  /*
    sender:     START_SEND   file_name   chunk_size      chunk  FINISH_SEND
    receiever:  OK_SEND      OK          OK_SEND_CHUNK   OK     OK_RECEIVED
  */

  IOSink? _outputStream;
  final WebSocket socket;
  String? destinationPath;

  num _incomingDataLength = 0;
  var _isStartingSend = false;
  var _isSending = false;
  var _totalSize = 0;
  num _sizeSent = 0;
  String? _fileDesc;
  Sender? _sender;
  final void Function(double percentage, int index) onSharing;

  Receiver(
      {required this.socket, this.destinationPath, required this.onSharing});

  void setSender(Sender sender) {
    _sender = sender;
  }

  void setFileName(String desc) {
    _fileDesc = desc;
  }

  void receiveHandler(dynamic event) async {
    // when Byte data is receiving
    if (event is! String) {
      _outputStream?.add(event);
      _incomingDataLength -= event?.length;
      _sizeSent += event?.length;
      // onSharing((_sizeSent / _totalSize), 0);

      // check whether all data in the chunk has been transferred
      if (_incomingDataLength == 0) {
        socket.add(CommunicationChannel.OK);
      }
      return;
    }
    //clipbaod data
    // if (!_isFileSharing) {
    //   await Clipboard.setData(ClipboardData(text: event));
    //   LastCopied.str = event;
    //   return;
    // }
    if (_isStartingSend) {
      // Sender -> Receiver (3)
      _isStartingSend = false;
      _isSending = true;
      var i = event.length - 1;
      while (event[i] != ' ') {
        i--;
      }
      final fileName = event.substring(0, i);
      final size = event.substring(i + 1);
      _totalSize = int.parse(size);
      _sizeSent = 0;
      FileClient.createFile(fileName: fileName, path: destinationPath)
          .then((file) {
        _outputStream = file.openWrite();
        socket.add(CommunicationChannel.OK);
      });
    } else if (event == CommunicationChannel.FINISH_SEND) {
      // Sender -> Receiver (8)
      // _isFileSharing = false;
      _isSending = false;
      _outputStream?.close();
      socket.add(CommunicationChannel.OK_RECEIVED);
    } else if (_isSending) {
      // Sender -> Receiver (5)

      _incomingDataLength = int.parse(event);
      socket.add(CommunicationChannel.OK_SEND_CHUNK);
    } else if (event == CommunicationChannel.OK_SEND_CHUNK) {
      // Receiver -> Sender (6)

      _sender?.sendChunk();
    } else if (event == CommunicationChannel.START_SEND) {
      // Sender -> Receiver (1)
      // _isFileSharing = true;
      _isStartingSend = true;
      socket.add(CommunicationChannel.OK_SEND);
    } else if (event == CommunicationChannel.OK_SEND) {
      // Receiver -> Sender (2)

      socket.add(_fileDesc);
    } else if (event == CommunicationChannel.OK_RECEIVED) {
      // Receiver -> Sender (9)

      _fileDesc = _sender?.sendFile();
      if (_fileDesc != null) {
        socket.add(CommunicationChannel.START_SEND);
      }
      // else
      //   _isFileSharing = false;
    } else if (event == CommunicationChannel.OK) {
      // Receiver -> Sender (4/7)
      _sender?.sendChunkSize();
    }
  }
}
