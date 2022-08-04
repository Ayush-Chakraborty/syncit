import 'dart:io';
import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:syncit/secondary_communication/secondary_communication_channel.dart';
import 'package:syncit/services/file_client.dart';

// import 'clipboard.dart';
import 'communication/communication_channel.dart';
import 'services/network_client.dart';

class Share with ChangeNotifier {
  // signals
  var _isConnected = false;
  var _isScanning = false;
  var _qrCode = '';
  String? _path;
  var _percentageSent = 0.0;
  var _sendingFileIndex = -1;
  var _isSending = false;
  var _isReceiving = false;

  // var _clipboardSyncing = false;

  List<PlatformFile> _files = [];
  WebSocket? _socket;
  CommunicationChannel? communicationChannel;
  NetworkClient? _networkClient;

  // WebSocket? _secondarySocket;
  // SecondaryCommunicationChannel? secondaryCommunicationChannel;
  // NetworkClient? _secondaryNetworkClient;

  String get qrCode => _qrCode;
  bool get isConnected => _isConnected;
  List<PlatformFile> get files => _files;
  double get percentSent => _percentageSent;
  int get sendingFileIndex => _sendingFileIndex;
  bool get isSending => _isSending;
  bool get isReceiving => _isReceiving;

  void setFiles(List<PlatformFile> files) {
    _files = files;
    notifyListeners();
  }

  void onSharing(double percetage, int index) {
    _percentageSent = percetage;
    _sendingFileIndex = index;
    if (index == -1) {
      _isSending = false;
      _files.clear();
    }
    notifyListeners();
  }

  void _onConnect(WebSocket socket) {
    _isConnected = true;
    _socket = socket;
    notifyListeners();

    communicationChannel = CommunicationChannel(
        socket: _socket!, destinationPath: _path, onSharing: onSharing);
    _networkClient
        ?.setReceiver((communicationChannel?.receiver?.receiveHandler)!);
  }

  // void _secondaryOnConnect(WebSocket socket) {
  //   _secondarySocket = socket;
  //   secondaryCommunicationChannel =
  //       SecondaryCommunicationChannel(socket: _secondarySocket!);
  //   _secondaryNetworkClient
  //       ?.setReceiver((secondaryCommunicationChannel?.receiveHandler)!);
  // }

  void _onDisconnect() {
    _isConnected = false;
    notifyListeners();
  }

  void disconnectSocket() async {
    _socket?.close();
    _isConnected = false;
    notifyListeners();
  }

  Future<void> desktopInitialSetup() async {
    final server = Server(
        uri: "syncit/primary",
        onConnect: _onConnect,
        onDisconnect: _onDisconnect);
    final ipList = await server.getIps();
    final qrCode = await server.getQrCode(ipList);
    _networkClient = server;
    _qrCode = qrCode;
    // final secondaryServer = Server(
    //     onConnect: _secondaryOnConnect,
    //     onDisconnect: () {},
    //     uri: "syncit/secondary");
    // await secondaryServer.getQrCode(ipList);
    // _secondaryNetworkClient = secondaryServer;
  }

  void mobileSetup() async {
    final status = await Permission.accessMediaLocation.isDenied;
    if (status) {
      await Permission.accessMediaLocation.request();
    }
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      _files = FileClient.pickFilesFromIntent(value);
    });
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      _files = FileClient.pickFilesFromIntent(value);
    }, onError: (err) {});
  }

  // StreamSubscription<String>? clipboard;
  StreamSubscription? _intentDataStreamSubscription;
  var numFiles = 0;

  Future<void> onQrDetect(String? qrCode) async {
    if (qrCode == null) return;
    final socket = Socket(
        uri: "syncit/primary",
        onConnect: _onConnect,
        onDisconnect: _onDisconnect);
    _networkClient = socket;
    await socket.connectSocket(qrCode);

    // final secondarySocket = Socket(
    //     onConnect: _secondaryOnConnect,
    //     onDisconnect: () {},
    //     uri: "syncit/secondary");
    // secondarySocket.connectSocket(qrCode);
    // _secondaryNetworkClient = secondarySocket;
  }

  void dispose() {
    _intentDataStreamSubscription?.cancel();
    // clipboard?.cancel();
    super.dispose();
  }

  void sendFiles() {
    // _sendingFileIndex = 0;
    // _isSending = true;
    // notifyListeners();
    communicationChannel?.sendFiles(_files);
  }
}
