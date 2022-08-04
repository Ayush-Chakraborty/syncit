import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncit/communication/receiver.dart';

class NetworkClient {
  final void Function(WebSocket webSocket) onConnect;
  final VoidCallback onDisconnect;
  void Function(dynamic event)? receiveHandler;
  final String uri;

  NetworkClient(
      {required this.uri, required this.onConnect, required this.onDisconnect});

  void setReceiver(void Function(dynamic event) handler) {
    receiveHandler = handler;
  }
}

class Socket extends NetworkClient {
  // for mobile
  Socket(
      {required super.uri,
      required super.onConnect,
      required super.onDisconnect});

  Future<void> connectSocket(String qrCode) async {
    final ipAddress = qrCode.split(' ');

    // try connecting to available ip addresses
    for (var ip in ipAddress) {
      // filter valid ip addresses
      var totalDots = 0;
      for (int i = 0; i < ip.length; i++) {
        if (ip[i] == '.') totalDots++;
      }
      if (totalDots != 3) continue;

      try {
        // print(ip);
        final socket = await WebSocket.connect('ws://$ip:9999/$uri')
            .timeout(const Duration(seconds: 15), onTimeout: () {
          throw Exception("Not Connected");
        });
        onConnect(socket);

        // clipboard = clipboardSync().listen((data) {
        //   if (!_isFileSharing) _socket?.add(data);
        // });
        socket.listen((event) => receiveHandler!(event), onDone: () {
          onDisconnect();
          // clipboard?.cancel();
        });
        break;
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

class Server extends NetworkClient {
  // for desktop
  final List<HttpServer> _servers = [];

  Server(
      {required super.uri,
      required super.onConnect,
      required super.onDisconnect});

  Future<List<String>> getIps() async {
    List<String> ipAddress = [];
    final interfaces = await NetworkInterface.list();

    // fliter the IPv4 ip addresses
    for (var network in interfaces) {
      for (var address in network.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          // ignoring the lan ip addresses
          final ipSplited = address.address.split('.');
          if (ipSplited.last != '1' && ipSplited.last != '0') {
            ipAddress.add(address.address);
          }
        }
      }
    }
    return ipAddress;
  }

  Future<String> getQrCode(List<String> ipAddresses) async {
    var availabeIps = '';

    // setup servers for the available ip addresses
    for (var ip in ipAddresses) {
      try {
        final server = await HttpServer.bind(ip, 9999);
        availabeIps = '$availabeIps $ip';
        print(server.address);
        server.listen((HttpRequest req) async {
          if (req.uri.path == '/$uri') {
            final socket = await WebSocketTransformer.upgrade(req);
            for (var otherServer in _servers) {
              await otherServer.close();
            }
            onConnect(socket);
            // clipboard = clipboardSync().listen((data) {
            //   if (!_isFileSharing) _socket?.add(data);
            // });
            socket.listen((event) => receiveHandler!(event), onDone: () {
              onDisconnect();
              //   _setupServer();
              // clipboard?.cancel();
            });
          }
        });
        _servers.add(server);
      } catch (_) {}
    }
    return availabeIps;
  }
}
