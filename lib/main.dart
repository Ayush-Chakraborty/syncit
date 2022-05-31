// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_desktop_folder_picker/flutter_desktop_folder_picker.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SyncIt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // signals

  /*
    sender:     START_SEND   file_name   chunk_size      chunk  FINISH_SEND
    receiever:  OK_SEND      OK          OK_SEND_CHUNK   OK     OK_RECEIVED
  */

  static const START_SEND = "START_SEND";
  static const FINISH_SEND = "FINISH_SEND";
  static const OK_SEND = "OK_SEND";
  static const OK_RECEIVED = "OK_RECEIVED";
  static const OK_SEND_CHUNK = "OK_SEND_CHUNK";
  static const OK = "OK";
  static const MAX_CHUNK = 100 * 65500;

  var _totalSize = 0;
  var _sizeSent = 0;
  var _lastSizeSent = 0;
  var _percentageSent = 0.0;
  var _sendingFileIndex = 0;
  var _isConnected = false;
  var _isStartingSend = false;
  var _isSending = false;
  var _isScanning = false;
  var _qrCode = '';
  var _fileName = '';
  num _incomingDataLength = 0;

  var _inputStream = StreamController<List<int>>().stream;
  final List<HttpServer> _servers = [];
  List<String> _ipAddress = [];
  List<PlatformFile> _files = [];
  WebSocket? _socket;
  File? _selectedFile;
  IOSink? _outputStream;
  String? _path;

  void _pickfile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    _files = result.files;
    _sendingFileIndex = 0;
  }

  void _sendFile() async {
    final file = _files[_sendingFileIndex];
    _fileName = file.name;
    _selectedFile = File(file.path ?? '');
    _totalSize = file.size;
    _sizeSent = 0;
    _socket?.add(START_SEND);
  }

  Future<void> _createFile(String fileName) async {
    // to detect file type
    final type = lookupMimeType(fileName)?.split('/')[0];

    if (Platform.isAndroid) {
      // create file based upon file type

      Directory? directory;
      if (type == "image") {
        final dcimPath = await AndroidPathProvider.dcimPath;
        directory = Directory('$dcimPath/SyncIt/Images');
      } else if (type == 'video') {
        final dcimPath = await AndroidPathProvider.dcimPath;
        directory = Directory('$dcimPath/SyncIt/Videos');
      } else if (type == 'audio') {
        final audioPath = await AndroidPathProvider.musicPath;
        directory = Directory('$audioPath/SyncIt');
      }
      if (directory == null) {
        final documentPath = await AndroidPathProvider.documentsPath;
        directory = Directory('$documentPath/SyncIt');
      }
      var doesExist = await directory.exists();
      if (!doesExist) {
        await directory.create(recursive: true);
      }
      _path = directory.path;
      _selectedFile = File('$_path/$fileName');
    } else if (Platform.isWindows) {
      // if destination folder is already selected save file there

      if (_path == null) {
        // create file based upon file type in documents folder
        Directory? directory;
        final documentDirectory = await getApplicationDocumentsDirectory();
        final documentPath = documentDirectory.path;
        if (type == "image")
          directory = Directory('$documentPath\\SyncIt\\Images');
        else if (type == 'video')
          directory = Directory('$documentPath\\SyncIt\\Videos');
        else if (type == 'audio')
          directory = Directory('$documentPath\\SyncIt\\Audios');
        else
          directory = Directory('$documentPath\\SyncIt\\Documents');

        var doesExist = await directory.exists();
        if (!doesExist) {
          await directory.create(recursive: true);
        }
        _path = directory.path;
      }
      _selectedFile = File('$_path/$fileName');
    }
  }

  void _sendChunkSize() {
    _lastSizeSent = _sizeSent;
    if (_sizeSent + MAX_CHUNK >= _totalSize) {
      _inputStream = _selectedFile?.openRead(_sizeSent) as Stream<List<int>>;
      _sizeSent = _totalSize;
    } else {
      _inputStream = _selectedFile?.openRead(_sizeSent, _sizeSent + MAX_CHUNK)
          as Stream<List<int>>;
      _sizeSent += MAX_CHUNK;
    }
    _socket?.add((_sizeSent - _lastSizeSent).toString());
  }

  void _sendChunk() async {
    var temp = _lastSizeSent;
    _inputStream.listen((data) {
      _socket?.add(data);
      temp = min(_sizeSent, temp + data.length);
      setState(() {
        _percentageSent = (temp / _totalSize) * 100;
      });
    });
  }

  void _receiveHandler(event) async {
    // when Byte data is receiving
    if (event is! String) {
      _outputStream?.add(event);
      _incomingDataLength -= event?.length;

      // check whether all data in the chunk has been transferred
      if (_incomingDataLength == 0) {
        _socket?.add(OK);
      }
      return;
    }
    // print(event);
    if (_isStartingSend) {
      // Sender -> Receiver (3)
      _isStartingSend = false;
      _isSending = true;
      _createFile(event).then((_) {
        _outputStream = _selectedFile?.openWrite();
        _socket?.add(OK);
      });
    } else if (event == FINISH_SEND) {
      // Sender -> Receiver (8)

      _isSending = false;
      _outputStream?.close();
      _socket?.add(OK_RECEIVED);
    } else if (_isSending) {
      // Sender -> Receiver (5)

      _incomingDataLength = int.parse(event);
      _socket?.add(OK_SEND_CHUNK);
    } else if (event == OK_SEND_CHUNK) {
      // Receiver -> Sender (6)

      _sendChunk();
    } else if (event == START_SEND) {
      // Sender -> Receiver (1)

      _isStartingSend = true;
      _socket?.add(OK_SEND);
    } else if (event == OK_SEND) {
      // Receiver -> Sender (2)

      _socket?.add(_fileName);
    } else if (event == OK_RECEIVED) {
      // Receiver -> Sender (9)

      _sendingFileIndex++;
      if (_sendingFileIndex < _files.length) _sendFile();
    } else if (event == OK) {
      // Receiver -> Sender (4/7)

      if (_sizeSent >= _totalSize) {
        _socket?.add(FINISH_SEND);
        return;
      }
      _sendChunkSize();
    }
  }

  void _connectWebSocket() async {
    _ipAddress = _qrCode.split(' ');

    // try connecting to available ip addresses
    for (var ip in _ipAddress) {
      // filter valid ip addresses
      var totalDots = 0;
      for (int i = 0; i < ip.length; i++) {
        if (ip[i] == '.') totalDots++;
      }
      if (totalDots != 3) continue;

      try {
        final skt = await WebSocket.connect('ws://$ip:9999/syncit')
            .timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception("Not Connected");
        });
        _socket = skt;
        setState(() {
          _isConnected = true;
        });
        _socket?.listen((event) => _receiveHandler(event), onDone: () {
          setState(() {
            _isConnected = false;
          });
        });
        break;
      } catch (_) {}
    }
    setState(() {
      _isScanning = false;
    });
  }

  void _setupServer() async {
    var availabeIps = '';

    // setup servers for the available ip addresses
    for (var ip in _ipAddress) {
      try {
        final server = await HttpServer.bind(ip, 9999);
        availabeIps = '$availabeIps $ip';
        server.listen((HttpRequest req) async {
          if (req.uri.path == '/syncit') {
            _socket = await WebSocketTransformer.upgrade(req);
            for (var otherServer in _servers) {
              await otherServer.close();
            }

            setState(() {
              _isConnected = true;
            });
            _socket?.listen((event) => _receiveHandler(event), onDone: () {
              setState(() {
                _isConnected = false;
                _setupServer();
              });
            });
          }
        });
        _servers.add(server);
      } catch (_) {}
    }
    setState(() {
      _qrCode = availabeIps;
    });
  }

  void _disconnectSocket() async {
    _socket?.close();
    setState(() {
      _isConnected = false;
    });
  }

  void _folderPick() async {
    // for desktop
    final directoryPath =
        await FlutterDesktopFolderPicker.openFolderPickerDialog();
    if (directoryPath == null) return;
    final directory =
        await Directory('$directoryPath/SyncIt').create(recursive: true);
    _path = directory.path;
  }

  Future<void> _getIps() async {
    // for desktop
    final interfaces = await NetworkInterface.list();

    // fliter the IPv4 ip addresses
    for (var network in interfaces) {
      for (var address in network.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          // ignoring the lan ip addresses
          final ipSplited = address.address.split('.');
          if (ipSplited.last != '1' && ipSplited.last != '0')
            _ipAddress.add(address.address);
        }
      }
    }
  }

  void _desktopInitialSetup() {
    _getIps().then((_) => _setupServer());
  }

  void _mobileSetup() async {
    final status = await Permission.accessMediaLocation.isDenied;
    if (status) {
      await Permission.accessMediaLocation.request();
    }
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isWindows)
      _desktopInitialSetup();
    else if (Platform.isAndroid) _mobileSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isScanning
          ? Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) {
                      if (barcode.rawValue != null) {
                        _qrCode = barcode.rawValue!;
                        _connectWebSocket();
                      }
                    }),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (Platform.isAndroid)
                    ElevatedButton(
                        onPressed: () => setState(() {
                              _isScanning = true;
                            }),
                        child: const Text(" Scan & Connect")),
                  ElevatedButton(
                      onPressed: _disconnectSocket,
                      child: const Text("Disconnect")),
                  ElevatedButton(
                      onPressed: _pickfile, child: const Text("Pick files")),
                  ElevatedButton(
                      onPressed: _sendFile, child: const Text("Send files")),
                  if (Platform.isWindows)
                    ElevatedButton(
                        onPressed: _folderPick,
                        child: const Text("Select Destination Folder")),
                  Text(_isConnected ? "Connected" : "Not Connected"),
                  Text("${_percentageSent.toStringAsFixed(2)} %"),
                  if (Platform.isWindows && _qrCode.isNotEmpty)
                    QrImage(
                      data: _qrCode,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
